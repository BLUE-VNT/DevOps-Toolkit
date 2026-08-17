# Project Catalog

> A central catalog for projects, Git repositories, and project descriptions.
> Last updated: 2026-08-17

| No. | Project | Git Repository | Description |
| ---: | --- | --- | --- |
| 1 | Chrome-Plugin-Xiaohongshu-Downloader | [Git repository](https://github.com/BLUE-VNT/Chrome-Plugin-Xiaohongshu-Downloader) | A Chrome extension for downloading images and videos from Xiaohongshu (RedNote). It supports single-note downloads, media selection, batch URL downloads, ZIP archives, local history, custom filenames, and duplicate protection. |
| 2 | Chrome-Plugin-Facebook-Downloader | [Git repository](https://github.com/BLUE-VNT/Chrome-Plugin-Facebook-Downloader) | A Chrome extension for saving Facebook photos and videos already available in the signed-in browser session. It supports posts, Reels, Watch, Stories, Home Feed scanning, batch downloads, ZIP archives, and local DASH-to-MP4 remuxing. |
| 3 | Chrome-Plugin-Instagram-Downloader | [Git repository](https://github.com/BLUE-VNT/Chrome-Plugin-Instagram-Downloader) | A Chrome extension for saving supported Instagram and Threads images and videos. It provides inline controls, multi-item selection, profile and feed scanning, individual or ZIP downloads, history, custom naming, and duplicate detection. |
| 4 | Chrome-Plugin-Twitter-Downloader | [Git repository](https://github.com/BLUE-VNT/Chrome-Plugin-Twitter-Downloader) | A Chrome extension for downloading original-quality photos and the highest-bitrate MP4 media exposed by X/Twitter posts. It supports selective post downloads, self-threads, filtered batch downloads, ZIP archives, local history, statistics, and duplicate protection. |
| 5 | Chrome-Plugin-Bilibili-Downloader | [Git repository](https://github.com/BLUE-VNT/Chrome-Plugin-Bilibili-Downloader) | A Chrome extension for downloading Bilibili videos, audio, thumbnails, images, and comments. It supports local DASH-to-MP4 muxing, page scanning, batch and ZIP downloads, player enhancements, AI subtitle translation, and 16 UI languages. |

## Project Details

### 1. Chrome-Plugin-Xiaohongshu-Downloader

- **Git repository:**
  <https://github.com/BLUE-VNT/Chrome-Plugin-Xiaohongshu-Downloader>
- **Purpose:** The extension simplifies selecting and saving images and videos
  already available on supported Xiaohongshu or RedNote pages. It provides
  single-note and batch workflows while keeping download settings and history
  in the browser.
- **Core features:**
  - Downloads images, image collections, and videos from individual notes, with
    media selection for notes containing multiple files.
  - Imports URL lists from pasted text, UTF-8 TXT files, or single-column CSV
    files, with input validation and bounded download concurrency.
  - Saves selected media as separate files or a ZIP archive and supports custom
    download folders, filename templates, and username-based grouping.
  - Stores local download history, queue state, settings, and downloaded-item
    records for duplicate detection and controlled redownloads.
  - Limits media access to Xiaohongshu, RedNote, and their related CDN hosts and
    does not bypass authentication or platform access controls.
- **Use cases:** Saving authorized Xiaohongshu or RedNote images and videos for
  personal offline access, basic post archiving, or organized media review.
- **Technology:** A Chrome Manifest V3 extension built with WXT, TypeScript,
  React 19, JSZip, and the Chrome Extension API. Vitest, ESLint, and TypeScript
  type checking are used for quality assurance.

### 2. Chrome-Plugin-Facebook-Downloader

- **Git repository:**
  <https://github.com/BLUE-VNT/Chrome-Plugin-Facebook-Downloader>
- **Purpose:** The extension makes it easier to detect, organize, and save
  Facebook media that is already accessible in the user's signed-in browser
  session. It also handles videos delivered as separate DASH video and audio
  tracks by remuxing compatible tracks locally into MP4 files.
- **Core features:**
  - Provides download controls for photos, videos, Reels, Watch content,
    Stories, and supported Home Feed, group, and post surfaces.
  - Scans the Home Feed for available media and lets users filter, preview,
    select, and batch-download files or package them into ZIP archives.
  - Captures compatible DASH tracks and remuxes them locally with packaged
    `ffmpeg.wasm`; media processing does not rely on a backend service.
  - Offers popup and options interfaces for download settings, filename
    templates, themes, local media cache management, and optional download
    history.
  - Limits host access to Facebook web surfaces and `fbcdn.net`. It does not
    collect Facebook credentials, issue extra GraphQL requests for author data,
    or bypass login, DRM, privacy controls, or paywalls.
- **Use cases:** Saving authorized Facebook photos and videos for personal
  offline access, archiving public or permitted posts, and collecting multiple
  media items from the Home Feed for later review or organization.
- **Technology:** A Chrome Manifest V3 extension built with WXT, TypeScript,
  React 19, `ffmpeg.wasm`, Zod, WebExtension Polyfill, and the Chrome Extension
  API. It uses Vitest for unit tests, Playwright for end-to-end tests, and
  ESLint, Prettier, and TypeScript checks for quality assurance.

### 3. Chrome-Plugin-Instagram-Downloader

- **Git repository:**
  <https://github.com/BLUE-VNT/Chrome-Plugin-Instagram-Downloader>
- **Purpose:** The extension reduces the manual work required to discover,
  select, and save media from supported Instagram and Threads pages. It adds
  download controls to the page and processes media already available to the
  user's browser without bypassing platform access controls.
- **Core features:**
  - Downloads images and videos from supported Instagram posts, carousels,
    Reels, and Stories, as well as supported Threads posts and profiles.
  - Provides inline download controls, popup previews, media-type filters, and
    a picker for selecting one or more items from multi-media content.
  - Scans visible profile or feed media, can load additional profile items, and
    saves selected files individually or together in a ZIP archive.
  - Stores naming, folder, notification, language, theme, auto-fetch, history,
    and duplicate-detection preferences locally, with persistent download
    queues and downloaded-item records.
  - Includes a localized popup and About page. Optional sign-in, analytics,
    reporting, rating, and update behavior depends on explicit build and user
    configuration.
  - Limits host access to Instagram, Threads, their media CDNs, and configured
    authentication or reporting services. It does not bypass login or other
    Instagram and Threads access controls.
- **Use cases:** Saving authorized posts for personal offline access, archiving
  public or permitted visual content, and organizing media collected from
  profiles, feeds, Reels, Stories, or Threads for later review.
- **Technology:** A Chrome Manifest V3 extension built with WXT, TypeScript,
  React 19, JSZip, and the Chrome Extension API. It uses Vitest for unit tests,
  an optional browser smoke test, and ESLint, Prettier, TypeScript compilation,
  production-build, and generated-manifest checks for quality assurance.

### 4. Chrome-Plugin-Twitter-Downloader

- **Git repository:**
  <https://github.com/BLUE-VNT/Chrome-Plugin-Twitter-Downloader>
- **Purpose:** The extension simplifies discovering, selecting, and saving
  media already exposed by X/Twitter pages. It provides per-post and batch
  workflows while keeping media detection, download history, and statistics in
  the browser.
- **Core features:**
  - Downloads original-size photos, the highest-bitrate available MP4 video,
    and animated GIF posts as their MP4 media variants.
  - Adds a post control for downloading all media or previewing and selecting
    individual items, with automatic retry and explicit redownload confirmation
    for posts already recorded as successful.
  - Detects media posts from the root author in a loaded self-thread and
    downloads them sequentially in chronological order while excluding replies
    from other accounts.
  - Scans media already detected in the active tab, filters saved posts,
    reposts, photos, or videos, and downloads visible results as separate files
    or a ZIP archive.
  - Supports configurable output directories and filename tokens, local
    IndexedDB history, duplicate protection, and a 30-day statistics dashboard
    with success rates and frequently downloaded accounts.
  - Provides a localized interface with English, Vietnamese, and Simplified
    Chinese resources in the inspected checkout.
  - Additional owner-confirmed capabilities pending synchronization with the
    inspected local and GitHub repositories include an About page, update
    checking, a user rating prompt, and translation for comments and replies.
  - Limits host access to X/Twitter and their image and video hosts. It uses
    responses already requested by the page rather than issuing independent
    GraphQL requests, and it does not bypass authentication or access controls.
- **Use cases:** Saving authorized X/Twitter media for offline access, archiving
  public or permitted posts and self-threads, and organizing batches of photos,
  videos, or animated media for later review.
- **Technology:** A Chrome Manifest V3 extension built with WXT, TypeScript,
  React 18, JSZip, IndexedDB through `idb`, Recharts, and the Chrome Extension
  API. It uses Vitest, jsdom, fake IndexedDB, Prettier, and TypeScript checks for
  automated verification.

### 5. Chrome-Plugin-Bilibili-Downloader

- **Git repository:**
  <https://github.com/BLUE-VNT/Chrome-Plugin-Bilibili-Downloader>
- **Purpose:** The extension lets users save Bilibili media already playable in
  their active browser session. It handles Bilibili's separate DASH video and
  audio tracks and can combine compatible streams into an MP4 locally without
  re-encoding or uploading media to a developer-operated service.
- **Core features:**
  - Detects Bilibili video pages, multi-part videos, and SPA navigation, then
    displays available resolutions and AVC, HEVC, AV1, and AAC streams when
    Bilibili exposes them.
  - Downloads a complete MP4, a source video track, a source audio track, or a
    thumbnail. Compatible DASH video and audio are muxed locally with packaged
    FFmpeg WebAssembly.
  - Scans video cards on home, profile, recommendation, and listing pages, and
    scans displayed Bilibili images. Selected or all results can be downloaded
    as separate files or a ZIP archive.
  - Exports comments and optional replies from video, Dynamic, and Opus pages
    to CSV or JSON, with date-range scanning, progress reporting, cancellation,
    and retained partial results.
  - Provides player enhancements including shortcuts, Danmaku defaults,
    overlays, theater lighting, zoom, screenshot save or copy, and frame
    stepping.
  - Supports 16 UI languages, light, dark, and system themes, custom download
    folders and filename templates, notifications, badge progress, an internal
    About page, and a locally managed user rating prompt.
  - Provides AI subtitle translation by capturing the active video's audio,
    transcribing it locally with Whisper, and translating the transcript text
    through OpenAI, DeepSeek, or a custom OpenAI-compatible provider. Users can
    configure source and target languages and choose how translated subtitles
    are displayed in the player.
  - Limits host access to Bilibili APIs and media hosts plus explicitly required
    translation providers. It does not bypass DRM, VIP or paid access,
    authentication, privacy controls, or regional restrictions.
- **Use cases:** Saving authorized Bilibili videos, audio, images, thumbnails,
  comments, and replies for offline access, research, personal archives, or
  organized media review, with translated subtitles for multilingual viewing.
- **Technology:** A Chrome Manifest V3 extension built with WXT, TypeScript,
  bundled FFmpeg WebAssembly, Hugging Face Transformers with local Whisper, and
  Chrome Extension APIs. It uses Vitest, ESLint, Prettier, TypeScript checks,
  contract validation, production builds, and output verification.
