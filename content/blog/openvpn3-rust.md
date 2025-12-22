---
title: "Why I Built a COSMIC-Native OpenVPN3 GUI (Even Though I Like the CLI)"
date: 2025-12-20
summary: "A pragmatic take on why desktop Linux needs first-class apps, even when the CLI already works—and how community feedback turned a Python prototype into a Rust reality."
tags: [linux, openvpn, rust, cosmic, desktop, iced]
---

## The Context: CLI Is Not the Enemy

I like the CLI. I use the OpenVPN3 CLI regularly, and for servers or automation, it’s the correct interface. But a desktop environment is not a server, and a desktop user is not a shell script.

If COSMIC is going to succeed as a serious desktop environment, common workflows need to be discoverable and visible without requiring a terminal session. VPNs are the perfect example of this gap.

## The Evolution: From Python to Rust

This project actually started as a Python/PyQt5 application. It worked well enough as a proof of concept, but it felt like a guest on the system rather than a resident. 

![The Original Python Prototype - Functional, but the UI was a bit 'boring'](https://preview.redd.it/built-a-full-openvpn3-gui-for-linux-tested-on-cosmic-live-v0-n1y15b5ssw6g1.png?width=1080&crop=smart&auto=webp&s=27148542470967daaa3bfdfd8d1a8f787083c13b)
*The initial Python/PyQt5 version. It proved the demand was there, but it didn't feel 'COSMIC'.*

After sharing the prototype on r/pop_os, the feedback was clear: if I wanted it to be a true "first-class citizen" of the COSMIC ecosystem, I needed a more performant foundation. I decided to rewrite the entire thing in **Rust using the Iced framework**.

![The Rust/Iced Evolution - Native look and feel with better performance](https://preview.redd.it/update-openvpn3-gui-now-rebuilt-in-rust-repo-link-included-v0-x5bo9zqyea7g1.png?width=1080&crop=smart&auto=webp&s=47c52d3bba5ea9abec5d256cefa30bd891421f87)
*The Rust rewrite: Faster, lighter, and much closer to the modern Linux desktop aesthetic.*

## Why the GUI Wins: Features You Can't \"Tail\"

A thin wrapper shouldn't just replicate CLI commands; it should surface data that is tedious to track in a terminal. 

- **Live Traffic Graph:** Real-time visualization of throughput (Bytes in/out) and latency monitoring.
- **SSO & 2FA Support:** Handles modern authentication flows by automatically handing off to your default browser and reflecting the result in the UI.
- **Wayland Tray Integration:** A functional system tray icon that works under Wayland, allowing you to monitor status without keeping the main window open.
- **Recent Configurations:** A quick-access dropdown for your most used profiles, so you aren't hunting through directories for `.ovpn` files.

## Tech Stack: Rust, Iced, and libcosmic

Choosing Rust wasn't about being trendy; it was about stability. The app can sit quietly in the background for days with a negligible memory footprint. 

Following some great feedback from the System76 team (thanks **mmstick**!), the project is moving toward deeper **libcosmic** integration. This ensures the app respects the system’s theme engine (Light/Dark mode) and handles Wayland windowing exactly how COSMIC expects.

## Current Status

The project is currently in early alpha but is already "daily-driver" ready:
- **Connect / Disconnect** with one click.
- **Real-time network stats** & session monitoring.
- **Log Export** for when things inevitably go wrong.
- **Auto-reconnect** on drop.

*Known quirks:* I'm still refining the session persistence when the UI is closed, and the dock icon currently requires manual pinning in the alpha build of COSMIC.

## Where to Find It

The project lives here:
- [https://github.com/fonzi/openvpn-gui-rust](https://github.com/fonzi/openvpn-gui-rust)

Feedback is welcome the scope is intentionally small to keep the project sustainable, but the goal is to make it the best VPN client for the modern Linux desktop.