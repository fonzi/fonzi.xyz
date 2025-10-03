
---
title: "Testing HTML5 Canvas with CanvasGrid"
date: 2025-10-03
summary: "How I built a Playwright-first library to make automated canvas testing easy, after my MapGrab integration broke."
tags: [playwright, canvas, testing, javascript]
---

## Why Canvas Testing Is Hard

HTML5 canvas elements are everywhere games, maps, drawing apps, custom visualizations. But testing them has always been a pain. Unlike regular DOM elements, you can't just select, click, or inspect canvas content with standard browser automation tools.

## The Two Camps of Canvas Testing

When it comes to automating canvas testing, there are generally two camps:

1. **Deserialization and Direct Calls:** Some tools try to "read" the canvas by deserializing its pixel data or using direct API calls. This can work for simple cases, but quickly gets complicated for dynamic or interactive canvases, and often requires deep integration with the app's code.

2. **ML/AI Training:** Others use machine learning or AI to visually recognize elements and simulate clicks or drags. This approach is powerful, but requires training data, setup, and can be overkill for simple interactions.

I wanted something easier to plug in for basic canvas actions like clicking, dragging, or finding tooltips. So I thought: why not just overlay a dynamic grid at test runtime? That way, you can interact with any region of the canvas, without needing to reverse-engineer its internals or train a model.

## Motivation: MapGrab Broke, So I Built This

I started working on `canvas-grid` after my MapGrab integration broke due to some layering confusion. Tooltips and overlays were appearing in the DOM only after canvas interactions, and existing tools couldn't reliably automate or verify these behaviors. I needed a way to:

- Click and drag on specific canvas regions
- Detect tooltips or overlays that appear in the DOM after canvas events
- Sample colors and verify rendering

## Introducing CanvasGrid

`canvas-grid` is a Playwright-first library for testing HTML5 canvas elements using a grid-based approach. It's experimental, but it makes previously impossible tests easy-ish:

- Overlay a grid on any canvas
- Click, drag, and hover on grid cells
- Sample pixel colors
- Find tooltips or DOM elements triggered by canvas events

## Example Usage

```typescript
import { test, expect } from '@playwright/test';
import { CanvasGrid } from 'canvas-grid';

test('canvas testing example', async ({ page }) => {
  await page.goto('https://your-canvas-app.com');
  const grid = new CanvasGrid(page)
    .locator('canvas')
    .gridSize(10, 8);  // 10 cols, 8 rows
  await grid.attach();
  await grid.clickCell(5, 4);
  await grid.hoverCell(3, 2);
  const color = await grid.sampleCell(5, 4);
  // Now check for tooltips or overlays
  const tooltip = await page.locator('.tooltip').textContent();
  expect(tooltip).toContain('Expected text');
});
```

## CanvasGrid in Action

Below there is a GIF showing CanvasGrid running against a test app:

### Dragging a Canvas Ball
{{< video src="/gridplaywright.webm" width="800" height="400">}}


## Real-World Benefits

With `canvas-grid`, you can finally automate:
- Drag-and-drop interactions
- Pixel-perfect UI checks
- DOM overlays triggered by canvas events
- Regression tests for games, maps, and more

## Try It Out

The project is still experimental, but you can find it in my repo. If you have feedback or want to contribute, reach out!

## Where to Find CanvasGrid

CanvasGrid lives here for now:

- [GitHub: Bison-Software/CanvasGrid](https://github.com/Bison-Software/CanvasGrid)
- [npm: @bisonsoftware/canvas-grid-playwright](https://www.npmjs.com/package/@bisonsoftware/canvas-grid-playwright?activeTab=readme)

This project is under my new company, Bison Software LLC.

Learn more at [bison.software](https://bison.software)
