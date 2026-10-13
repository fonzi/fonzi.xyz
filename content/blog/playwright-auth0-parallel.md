---
title: "Parallel Playwright Auth: Surviving Auth0's Session Pain"
date: 2025-11-21
summary: "How we built a robust Playwright auth fixture to handle Auth0's session limitations, and why it's worth the pain."
tags: [playwright, auth0, testing, automation, e2e]
---

## Auth0 The Painful Migration 

When we migrated our authentication to Auth0, we quickly discovered that Auth0's session model is not designed for parallel browser automation. Running Playwright tests in parallel led to all our workers sharing the same Auth0 session, which caused flaky tests, random logouts, and a world of pain. The root of the problem is that Auth0, like many SSO providers, stores session state in browser cookies. If multiple Playwright workers use the same user, they end up overwriting each other's sessions. This is manageable for manual QA, but a nightmare for automated, parallel E2E testing. One test might log in, another logs out, and suddenly all your tests fail.

To solve this, we built a Playwright fixture that dynamically discovers all available test users from environment variables. On startup, the fixture scans your `.env` for any variable matching patterns like `uname`, `plusname`, `proname`, `superuser`, and their numbered variants. Each variable represents a unique test user for a specific role or tier. When you run Playwright with multiple workers, each worker is assigned a unique user from the discovered pool in a round-robin fashion. For example, with eight workers and eight users, each worker gets its own user. If you have fewer users than workers, users are reused in order. Scaling up is as simple as adding more user credentials to your `.env` file and increasing the worker count no code changes required. Tests can still override the assigned user to log in as a different role, but each worker’s session remains isolated.

This architecture means you can scale your parallel E2E tests as far as you have users, with no session collisions and minimal config changes. The core logic is straightforward: scan the environment for user variables, assign each worker a user in round-robin fashion, and proceed to login with those credentials. As you add more users to your environment, your parallel test runs scale automatically.

One interesting outcome of this journey was how we ended up blending Playwright’s fixture system with the Page Object Model (POM) pattern. Playwright encourages the use of fixtures for dependency injection and test setup, while POM is a classic approach for encapsulating UI logic. In our solution, the auth fixture provides login/logout helpers and user context, while the actual login and logout flows are implemented as page objects. The fixture handles user assignment, session management, and exposes simple `auth.login()` and `auth.logout()` methods, while the page objects encapsulate the UI interactions for each flow. This separation keeps tests clean and readable, while making it easy to update UI logic in one place. It also plays nicely with Playwright’s parallelism and fixture injection, giving us the best of both worlds.


## The Downside of leaving things in serial mode, and the upside of working around limitations

The results speak for themselves. Before this architecture, a single deployment with nearly 3,000 tests took over 11 hours to complete due to Auth0 session collisions and forced serial execution. After implementing worker-based user isolation and true parallelization, we not only got back to our original two-hour runtime, but pushed it even further down to about 1.5 hours. This means faster feedback, more reliable releases, and a much happier team. The pain of setup is real, but the payoff is massive.

Of course, setting this up isn't trivial. You need to maintain a pool of test users, keep passwords and roles in sync, and update your `.env` and sometimes your test data when adding new users. Debugging user assignment can be tricky. But the payoff is huge: no more flaky parallel tests, true role isolation, and confidence that your auth flows work for every user type.

If you’re running Playwright tests against an Auth0-protected app, don’t settle for serial runs or flaky parallelism. Build (or borrow) a worker-isolated auth fixture, keep a pool of test users, and enjoy reliable, scalable E2E tests even if it takes some pain to get there.

Here’s a diagram of how the architecture fits together:

```text
┌────────────┐      ┌────────────┐      ┌────────────┐
│ .env file  │───▶  │ User Pool  │───▶  │ Playwright │
│ (users)    │      │ Discovery  │      │ Workers    │
└────────────┘      └────────────┘      └────────────┘
    |                   |                    |
    |  uname, plusname  |  Assign users      |  Each worker
    |  proname, ...     |  round-robin       |  gets unique
    |                   |                    |  session
```

For those interested in the full implementation, here is the complete (obfuscated and genericized) Playwright auth fixture class that powers this approach:

```typescript
import { test as base } from '@playwright/test';
// ... import your Login and Logout page objects, and any TOTP helpers as needed

export type UserTier = 'base' | 'plus' | 'pro' | 'super';

type AuthFx = {
    user: UserTier;
    auth: {
        login: () => Promise<void>;
        loginAs: (tier: UserTier) => Promise<void>;
        logout: () => Promise<void>;
    };
};

function getAvailableUsers(): { [key: string]: string } {
    const users: { [key: string]: string } = {};
    if (process.env.name) users['base'] = process.env.uname;
    if (process.env.plusname) users['plus'] = process.env.plusname;
    if (process.env.proname) users['pro'] = process.env.proname;
    if (process.env.superuser) users['super'] = process.env.superuser;
    const envKeys = Object.keys(process.env);
    envKeys.forEach(key => {
        const match = key.match(/^(name|plusname|proname|superuser)(\d+)$/);
        if (match && process.env[key]) {
            const baseType = match[1] === 'uname' ? 'base' :
                match[1] === 'superuser' ? 'super' :
                    match[1].replace('name', '');
            const userKey = `${baseType}${match[2]}`;
            users[userKey] = process.env[key] as string;
        }
    });
    return users;
}

function creds(tier: UserTier) {
    const availableUsers = getAvailableUsers();
    const userKey = Object.keys(availableUsers).find(key =>
        key.startsWith(tier === 'base' ? 'base' :
            tier === 'super' ? 'super' :
                tier)
    );
    if (!userKey || !availableUsers[userKey]) {
        throw new Error(`No ${tier} user found in environment variables`);
    }
    const email = availableUsers[userKey];
    const pass = tier === 'super' ? process.env.superpass : process.env.pass;
    if (!email || !pass) {
        throw new Error(`Missing credentials for ${tier} user`);
    }
    return { email, pass };
}

export const test = base.extend<AuthFx>({
    user: ['base', { option: true }],
    auth: async ({ page, user }, use) => {
        const loginPO = new Login(page);
        const logoutPO = new Logout(page);
        const doLogin = async (tier?: UserTier) => {
            // login flow: navigate, enter credentials, handle MFA, wait for login success
            // ...actual login logic goes here
        };
        await use({
            login: () => doLogin(),
            loginAs: (tier) => doLogin(tier),
            logout: async () => {
                await logoutPO.performLogout();
            },
        });
    },
});

export const expect = test.expect;
```

This class handles user discovery, assignment, login, logout, and role switching, and is designed to be extended and customized for your own Playwright E2E needs.

---

Here's a sample test showing how to use this fixture in practice. Note that we've further obfuscated the environment variable names for demonstration:

Example `.env` (obfuscated):
```env
APP_BASE_URL='https://your-app-url.com'
USER_A='user1@example.com'
USER_B='user2@example.com'
USER_C='user3@example.com'
ADMIN_USER='admin@example.com'
USER_PASS='YourPassword123!'
ADMIN_PASS='SuperSecret!'
```

Sample Playwright test:
```typescript
import { test } from '../fixture/auth';

test('Admin can access dashboard', async ({ auth }) => {
    await auth.loginAs('admin');
    // ...test admin dashboard logic
});

test('Regular user can view profile', async ({ auth }) => {
    await auth.login(); // Uses the worker's assigned user
    // ...test profile logic
});
```

This approach keeps your tests clean and role-aware, while the fixture handles all the session and user management under the hood.

## API Authentication: The Service Account Pattern

Another challenge we faced was authenticating our APIs in a way that worked with Auth0. For this, we had to create a dedicated "machine-to-machine" (M2M) or service account application in Auth0. This app is not the same as our main user-facing app it exists solely to issue tokens for backend and automated API access.

The process works like this: our test code (or backend service) sends a POST request to the Auth0 authentication server not the main app using the Auth0 client ID, client secret, and the correct audience for our API. Auth0 then returns a bearer token, which we can use to authenticate requests to our protected APIs.

Here's a simplified example of how this works in code:

```typescript
const url = `${process.env.AUTH_SERVER_URL}/oauth/token`;
const requestBody = {
  grant_type: "client_credentials",
  client_id: process.env.API_CLIENT_ID,
  client_secret: process.env.API_CLIENT_SECRET,
  audience: process.env.API_AUDIENCE
};

const response = await fetch(url, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(requestBody)
});
const data = await response.json();
const token = data.access_token;
```

This token can then be sent as a Bearer token in the `Authorization` header of any API request. This approach is essential for automated testing and backend integrations, and it keeps your API authentication decoupled from your user-facing login flows.

If you need to test user-level flows (with MFA, etc.), you can use a similar approach as shown in the `APILogin` class, but for most backend and CI/CD scenarios, the service account pattern is the way to go.

*Note: We also ended up injecting MFA (multi-factor authentication) into our flows for certain user-level tests, but that's a topic for another blog post on advanced Auth0 automation.*
