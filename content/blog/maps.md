---
title: "E2E Tests For Maps"
date: 2025-09-05T14:44:55-05:00
draft: false
---

# Testing Interactive Maps with Playwright and MapGrab

Maps are some of the trickiest UI components to test. They’re dynamic, data-driven, and highly interactive. Unlike static DOM elements, a map tile or layer isn’t just a <div> you can click(). You need to assert visibility on a canvas, zoom to a region, and sometimes even intercept the map’s internal events.

I recently built an automated test suite for map views using [Playwright](https://playwright.dev/) together with the [MapGrab](https://mapgrab.github.io/)

## 1. Merging Test Contexts

The first hurdle: getting Playwright and MapGrab expectations (expect) and fixtures (test) to coexist.

I solved this with a support file:

```typescript
// MapSupport.ts
import {
  test as playwrightTest,
  mergeTests,
  expect as playwrightExpect,
  mergeExpects,
} from "@playwright/test";
import { test as mapGrabTest, expect as mapGrabExpect } from "@mapgrab/playwright";

export const test = mergeTests(playwrightTest, mapGrabTest);
export const expect = mergeExpects(playwrightExpect, mapGrabExpect);
```

This gave me a unified test and expect that support both DOM checks and map-specific checks like toBeVisibleOnMap().

## 2. Bootstrapping the Map
Each test begins by logging in (via a Page Object) and asserting that the base “earth” layer is visible:
```typescript
const mapHelper = new MapHelper(page);
await mapHelper.assertEarthVisible();
```

This ensures the map actually rendered before deeper validation.

## 3. Custom Map Helper Class

To keep tests clean, I wrapped common interactions in a MapHelper class:

```typescript
public async fitTileToMap(code: string, browserName: string) {
  const tile = this.getTileLocator(code);
  await expect(tile).toBeVisibleOnMap();
  await tile.fitMap({ padding: this.getPadding(browserName) });
}
```

This method zooms/pans the map so the requested tile is centered. Padding logic accounts for browser rendering differences.

Clicking and validating tiles required a bit more work:


```typescript
public async clickAndVerifyInfoPanel(code: string, label: string) {
  const tile = this.getTileLocatorByLayer(code);
  const box = await tile.boundingBox();

  const clickX = box.x + box.width / 2;
  const clickY = box.y + box.height / 2;
  await this.page.mouse.click(clickX, clickY);

  const infoPanel = this.page.locator('.info-box');
  await expect(infoPanel).toBeVisible();
  await expect(infoPanel.locator('.layer-name')).toContainText(label);
}
```

This ensures not just that the tile exists, but that clicking it triggers the correct info panel and button set.

## 4. Handling Multiple Layers
The app supports multiple tile layers (e.g., layer vs. sublayer). I kept my helper flexible by passing a layer type:

```typescript
this.getTileLocatorByLayer(code, 'sublayer')
```

## 5. Injecting MapGrab into the App
5. Injecting MapGrab into the App

The scariest part was wiring MapGrab into the app’s map instance. The library expects a map object to hook into, but our app doesn’t export it by default.

The fix: install a stub and inject MapGrab on map load.

```typescript
// map-interface/index.ts
export function installMapGrab(..._args: unknown[]): void {
  // no-op stub for tests
}
```
And in the initializer:

```typescript
map.on('load', () => {
  installMapGrab(map, 'mainMap');
  this.mapReadySubject.next(map);
});

```
Now the tests can “see” the map internals without modifying production code.

## 6. Example Test

Here’s a simplified end-to-end test:

```typescript
test('Verify map view is loaded', async ({ page, browserName }) => {
  // log in
  const mapHelper = new MapHelper(page);
  await mapHelper.assertEarthVisible();
  
  // verify main tile
  await mapHelper.fitTileToMap("CODE123", browserName);
  await mapHelper.clickAndVerifyInfoPanel("CODE123", "Layer: Example");
  
  // verify sub-tile
  await mapHelper.fitTileToMap("CODE456", browserName);
  await mapHelper.clickAndVerifyInfoPanel("CODE456", "Sublayer: Example", "sublayer");
});

```

## 7. Lessons Learned

Maps require spatial awareness. Clicking at x, y is often more reliable than locator.click().
Cross-browser padding is essential. Different engines render map extents slightly differently.
Helper classes keep tests readable. Without MapHelper, the tests would be noisy and fragile.
Injection was the secret sauce. Without installing MapGrab on map load, expectations like toBeVisibleOnMap() wouldn’t work.
Browser limitation: currently this approach only works in Chromium (headless). Firefox and WebKit do not render the map in headless mode, so they can’t be validated with this setup.


## Conclusion

Testing maps isn’t as straightforward as testing forms or buttons. But with Playwright + MapGrab, plus some thoughtful helper code, you can validate tiles, layers, tooltips, and navigation in a way that’s both stable and maintainable.

This setup now runs in CI alongside other UI tests, giving confidence that when we say “the map is ready,” it actually is.
