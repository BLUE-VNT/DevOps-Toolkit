# Feature Prioritization and System Implementation Flow

## Introduction

This document summarizes the core features that should be considered when developing a Bilibili livestream support tool.

The content focuses on three main areas:

- Features to be developed.
- Core value delivered to users.
- Main system processing flow.

---

## Feature Table

| Rank | Feature | Core Value | System Flow |
|---:|---|---|---|
| 1 | **Chinese–English Bilingual Subtitles** | Removes the language barrier and helps KOLs reach international viewers. | Subtitle input → content normalization → Chinese–English translation → bilingual display on video |
| 2 | **Repeated Question Detection** | Helps KOLs identify questions that many viewers care about without reading all danmaku messages. | Danmaku → question detection → similar question grouping → occurrence counting → popular question display |
| 3 | **Question Queue** | Turns a chaotic danmaku stream into a controllable Q&A workflow. | Danmaku → question classification → add to queue → moderator sorting → KOL answers |
| 4 | **Live Event Timeline** | Records all important moments for live monitoring and post-live reuse. | Danmaku, Super Chat, and live metrics → event normalization → timestamping → timeline storage → display to KOL |
| 5 | **Abnormal Interaction Increase Alert** | Helps KOLs react immediately when content suddenly attracts a large number of viewers or interactions. | Viewers, danmaku, and likes → change calculation → spike detection → alert delivery → timeline logging |
| 6 | **Abnormal Interaction Drop Alert** | Detects early when content loses engagement or the livestream has issues. | Interaction metrics → time-window comparison → sharp drop detection → KOL alert → event logging |
| 7 | **Timestamped Subtitle Storage** | Creates foundational data for subtitle export, summarization, highlight discovery, and video post-production. | Live subtitles → sentence normalization → timestamping → subtitle storage → provide data for export and AI |
| 8 | **New Super Chat Alert** | Reduces missed supporter messages and improves the supporter experience. | Super Chat from Bilibili → event ingestion → unread status storage → popup or sound notification → moderator handling |
| 9 | **Feedback Danmaku Classification** | Helps KOLs separate real feedback from general comments. | Danmaku → content classifier → feedback label assignment → moderator filter → tracking and notes |
| 10 | **Negative Danmaku Classification** | Detects negative reactions, complaints, or brand image risks early. | Danmaku → sentiment analysis → negative label assignment → priority ranking → display to moderator or brand team |
| 11 | **Comment Keyword Statistics** | Shows which topics, products, or issues are being mentioned frequently by viewers. | Danmaku history → keyword extraction and normalization → frequency counting → similar keyword grouping → keyword table display |
| 12 | **Super Chat History Export** | Supports reconciliation, supporter care, and post-livestream reporting. | Super Chat storage → filter by session and time → data sorting → export formatting → history file download |
| 13 | **High-Engagement Topic Identification** | Helps KOLs understand which content should be further developed or reused. | Multi-session data → topic grouping → engagement aggregation → topic ranking → insight display |
| 14 | **Livestream Performance Comparison** | Helps evaluate long-term trends instead of looking at each session separately. | Session metrics → KPI normalization → select sessions for comparison → difference calculation → dashboard display |
| 15 | **Returning Viewer Analysis** | Measures retention capability and the development of a loyal community. | Viewer history → cross-session matching → returning viewer identification → retention rate calculation → report generation |
| 16 | **AI Subtitle Summary** | Reduces the time needed to review a livestream and quickly creates a post-session summary. | Subtitle storage → transcript cleanup → content segmentation → AI summary → user review and editing |
| 17 | **AI Popular Question Summary** | Turns thousands of questions into actionable insights for future content. | Danmaku history → question filtering → similar question grouping → AI summarization → popular question list generation |
| 18 | **AI Highlight Recommendation List** | Reduces the time editors spend finding moments worth turning into clips. | Timeline, transcript, and interaction metrics → time-segment scoring → ranking → timestamp list export |
| 19 | **Multi-Room Dashboard** | Allows MCNs or moderators to monitor multiple KOLs on one screen. | Multi-room connection → event ingestion per room → normalization and room tagging → resource management → dashboard display |
| 20 | **Auto Marker on Danmaku Spike** | Automatically marks moments with strong audience reactions to speed up highlight discovery. | Live danmaku → speed calculation over time → threshold detection → marker creation → display on editor timeline |
