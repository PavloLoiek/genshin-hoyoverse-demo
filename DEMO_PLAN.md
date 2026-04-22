# Demo Plan — Self-Learning Agents for HoYoverse (Genshin Impact)

**Audience:** Omilia CPO (Claudio) + C-level
**Presenter:** Pavlo
**Date:** April 22, 2026
**Format:** ~30-minute live demo mirroring Spiros's Self-Learning flow

---

## The one-line arc (memorise this)

> *"Four uploads. FAQ → API → Policy → Transcripts. Each one closes a gap the previous one left. After the fourth upload, the same caller who failed at stage 3 gets a beautiful resolution — without us writing a single line of code. That's the Self-Learning flywheel."*

---

# Part 1 — Setup (do these 10 minutes before the meeting)

## Step 0.1 — Open Finder to the demo folder

```
/Users/ploiek/Documents/JARVIS/Projects/Roadmap-Workshop-2026-04/output/genshin-hoyoverse/
```

In Finder: **Cmd+Shift+G**, paste the path above, Enter.
Inside, note the `manual_upload/` folder. Everything you'll drag into Copilot lives there, already split by stage:

```
manual_upload/
├── 1_faq/                   ← Stage 1 (2 files)
├── 2_api_specs/             ← Stage 2 (1 file)
├── 3_policies_and_sops/     ← Stage 3 (10 files)
└── 4_call_transcripts/      ← Stage 4 (12 files)
```

## Step 0.2 — Open 5 browser tabs in this order

| Cmd-# | Tab | URL |
|---|---|---|
| **Cmd+1** | Omilia Copilot UI | (whatever URL you use — pub.demo / US1 / local) |
| **Cmd+2** | This file | `file://...DEMO_PLAN.md` or open in Obsidian |
| **Cmd+3** | Swagger UI | https://genshin-hoyoverse.onrender.com/docs |
| **Cmd+4** | FAQ site | https://genshin-hoyoverse.onrender.com/ |
| **Cmd+5** | Cheatsheet | https://genshin-hoyoverse.onrender.com/cheatsheet |

(Skip tabs 3-5 if you didn't deploy to Render — see Part 3 at the bottom.)

## Step 0.3 — Create the Copilot project

1. In Copilot (Cmd+1), click **New Project** or **Create Project**.
2. Name it exactly: **HoYoverse — Genshin Impact**
3. Leave all documents empty. Don't upload anything yet.

## Step 0.4 — Warm up the Render service

Open in a browser: https://genshin-hoyoverse.onrender.com/health

Expected response (it takes up to 60s the first time — Render free tier sleeps):
```json
{"status":"ok","customer":"HoYoverse — Genshin Impact"}
```

If you get that → you're live. If you get 502 → wait 30s and refresh.

## Step 0.5 — Have this open on your phone

Open `https://genshin-hoyoverse.onrender.com/cheatsheet` on your phone. Backup if your laptop crashes.

---

# Part 2 — The Demo (run in order)

## Opening (2 min)

**SAY (verbatim or close to it):**

> *"Thanks for the time. I'm going to run the same Self-Learning demo Spiros ran yesterday, but on a vertical we don't currently serve — HoYoverse, makers of Genshin Impact. 60 million monthly players, massive support volume, four support pillars: account recovery, gacha complaints, payments, outage compensation. It's a stress test of the platform on a vertical you've never seen."*
>
> *"I'll do four uploads. FAQ. API specs. Policies. Call transcripts. After each one, the agent levels up. More importantly — four specific callers will fail at stage 3 and succeed at stage 4. Remember these names: Viktor, Sophie, Helen, Kaito. All four scenarios fail. All four resolve beautifully. That's the whole pitch."*

---

## Stage 1 — FAQ (3 min)

### 1.1 Upload

Files to drag into Copilot:
```
manual_upload/1_faq/index.html
manual_upload/1_faq/faq_document.docx
```

**How in Copilot UI:**
1. Open your new **HoYoverse — Genshin Impact** project.
2. Find the **Documents** tab (or the **Upload** zone).
3. Drag both files from Finder into the upload zone.
4. Wait ~10-15s for indexing. Both files should show "indexed" or similar.

### 1.2 Test calls — SAY these verbatim in the Copilot chat

**Call 1.1 — FAQ factual (should work)**
```
Hi, can you tell me what Welkin Moon includes?
```
**Expected:** Agent says something like *"Welkin Moon is a 30-day subscription that gives 300 Genesis Crystals immediately plus 90 Primogems per day for 30 days."*

If you get that → ✅ factual knowledge works.

---

**Call 1.2 — Account action (should fail)**
```
Hi, my UID is 832458917, can you check what my pity is on the Furina banner?
```
**Expected:** Agent apologises — something like *"I don't have access to player account data"* or *"I can explain how the pity system works but can't look up your specific counter."*

If you get that → ✅ no-hands story confirmed.

---

**Call 1.3 — Recovery general**
```
What do I do if I can't log into my account anymore?
```
**Expected:** Agent describes the general recovery process from FAQ but doesn't offer to start one.

### 1.3 SAY THIS after the calls (the punchline)

> *"The agent knows every policy and every FAQ topic. Ask it about pity, Welkin, refunds — it answers. But ask it to actually do something for Kaito — look up his pity counter — it can't. It has knowledge but no hands."*

**Optional:** Switch to Cmd+4 (FAQ tab) and scroll it briefly — *"this is the source material the agent learned from."*

**Transition:** *"Let's give it hands."*

---

## Stage 2 — API Specs (5 min)

### 2.1 Upload

File to drag in:
```
manual_upload/2_api_specs/genshin-hoyoverse_api.yaml
```

**How in Copilot UI:**
1. Same Documents tab.
2. Drag the YAML in.
3. Wait ~15s for the agent to parse the spec.

### 2.2 Test calls

**Call 2.1 — Pity lookup (should work cleanly)**
```
Hi, my UID is 832458917. What's my pity on the Furina banner?
```
**Expected:** Agent calls the API and returns something like *"You're at 15 pulls since your last 5-star on the Furina banner. No soft pity yet — that starts at pull 75."*

If you get that → ✅ APIs connected.

Switch briefly to **Cmd+3 (Swagger UI)** — point at `/api/player/{uid}/pity_counter` — *"that's the endpoint the agent just called live."*

---

**Call 2.2 — Minor refund (the compliance gap — script this one carefully)**
```
Hi, I just discovered my 12-year-old daughter spent 520 dollars on Genesis Crystals on my credit card over the last three days. I need a refund. Her UID is 705532108 and the order is ORD202604170012.
```
**Expected:** Agent will:
- Look up the order
- Start processing a refund **without asking if this is a minor account**
- **Without guardian verification**

**AS SOON AS THE AGENT STARTS PROCESSING** → interrupt verbally to the audience:

> *"Stop. Look at what it just did. A parent called about a child's $520 purchase. The agent didn't check the `is_minor` flag. It didn't ask for guardian verification. It didn't check the Minor Account Protection Policy because there's no policy loaded yet. It's processing a refund blind. In gaming this is a regulatory problem — every platform regulator is watching minor-account spend right now."*

---

**Call 2.3 — Outage comp (another compliance gap)**
```
My UID is 832118007, I want compensation for the recent outage.
```
**Expected:** Agent issues 300 Primogems without confirming which outage, whether Yuki's region was affected, or even what happened to Yuki specifically.

### 2.3 SAY THIS (wrap Stage 2)

> *"Now the agent has power. It can look up orders, process refunds, issue compensation. But it has no judgment — no verification, no policy checks, no amount read-back. It's a 16-year-old with the keys to the store. Let's give it the rulebook."*

---

## Stage 3 — Policies & SOPs (8 min — this is the emotional low)

### 3.1 Upload

Drag **all 10 files** from this folder:
```
manual_upload/3_policies_and_sops/
```

The 10 files are:
- `Account_Recovery_policy.docx`
- `Account_Recovery_sop.docx`
- `Wish_And_Gacha_Disputes_policy.docx`
- `Wish_And_Gacha_Disputes_sop.docx`
- `Top_Up_And_Refund_policy.docx`
- `Top_Up_And_Refund_sop.docx`
- `Compensation_And_Bugs_policy.docx`
- `Compensation_And_Bugs_sop.docx`
- `minor_account_protection_policy.docx`
- `general_training_guide.docx`

**How:** Cmd+A inside the folder, drag all 10 at once into the Copilot Documents zone. Wait ~30s for indexing.

### 3.2 Quick happy-path warmup (1 call — prove compliance kicked in)

**Call 3.0 — verify that identity check now happens**
```
Hi, my UID is 603245891, I forgot my password.
```
**Expected:** Agent now asks for email OTP verification BEFORE touching anything. Contrast with Stage 2 where it would have just reset.

> *"See — now it verifies identity first. That's the policy doing its job."*

### 3.3 The four edge-case failures (the story)

You don't have to do all four. Minimum is **Viktor + Kaito**. If time allows, Sophie is emotionally strong. Helen is the regulatory punchline.

---

#### ❌ Edge 1 — Viktor (Account Recovery)

**Say in chat:**
```
Hi, I can't log in, my account is locked. I don't have my UID, and I lost access to the email on the account a year ago. I'm a free-to-play player so I don't have any purchase receipts either.
```

**Expected agent response:** Asks for UID. When you explain again you don't have it, asks for email. When you explain again, escalates: *"Per the Account Recovery Policy, I need either the UID or email access to proceed. I'll transfer you to a supervisor."*

**SAY:**
> *"The SOP doesn't cover the path 'no UID and no email.' The agent followed it exactly. And that's a dead end."*

---

#### ❌ Edge 2 — Sophie (Wish & Gacha)

**Say in chat:**
```
Hi, my UID is 703321876. I've done 82 pulls on the Furina banner and I still don't have her. I spent about 100 dollars on this. I'm honestly about to quit the game.
```

**Expected:** Agent verifies, confirms 82 pulls, then says something like *"Per our Pity System Policy, the hard pity is at pull 90, and your situation is within expected parameters."*

**SAY:**
> *"The math is right. The language is wrong. That's a frustrated player about to walk, and the agent quoted 'expected parameters' at her. Your best humans don't talk like that."*

---

#### ❌ Edge 3 — Helen (Top-Up & Refund)

**Say in chat:**
```
Hi, this is Helen Williams. I need to report that my 12-year-old daughter Emma spent 520 dollars on Genesis Crystals on my credit card. Her UID is 705532108, order ID is ORD202604170012. I need that refunded.
```

**Expected:** Agent cites *"all sales of consumable items are final"* and suggests she dispute with her bank.

**SAY:**
> *"The same policy document ALSO has a Minor Account Protection clause. The agent read the first clause and missed the second. That's how regulatory complaints start."*

---

#### ❌ Edge 4 — Kaito (Compensation)

**Say in chat:**
```
Hi, my UID is 832458917. I lost two days of Spiral Abyss progress during the Asia outage last weekend. My Season Pass milestone was affected. This is incident INC202604161.
```

**Expected:** Agent verifies, confirms the incident, applies the standard 300 Primogems per the policy table, ends the call.

**SAY:**
> *"300 Primogems is the policy minimum. Your best human agents would escalate — maybe a couple of Fates, an apology, a grace period for the Season Pass. The policy doesn't forbid it. It just doesn't prescribe it. So the agent doesn't do it."*

### 3.4 Wrap Stage 3

> *"So now the agent is compliant. It verifies identity. It cites policy. It escalates correctly. But look at these four callers. Every one of them failed at a real edge that your best human agents handle every day. The SOP doesn't know what your humans know. Yet."*

**Transition:** *"Let's teach it from them."*

---

## Stage 4 — Call Transcripts (8 min — the emotional peak)

### 4.1 Upload

Drag **all 12 files** from:
```
manual_upload/4_call_transcripts/
```

Cmd+A inside the folder, drag all at once. Wait ~30s for indexing.

### 4.2 REPLAY the same four edge cases — SAME SCRIPT, different outcome

---

#### ✅ Replay 1 — Viktor

**Say (same as Stage 3):**
```
Hi, I can't log in, my account is locked. I don't have my UID, and I lost access to the email on the account a year ago. I'm a free-to-play player so no purchase receipts either.
```

**Expected agent flow:** Instead of asking for UID again, agent says something like *"Let me work through this with you"* and asks:
1. *"What server region?"* → **You say: "Europe"**
2. *"Roughly what Adventure Rank?"* → **You say: "about 53"**
3. *"Last 5-star you pulled?"* → **You say: "Venti"**
4. *"What device?"* → **You say: "iPhone 13"**

Then: *"High-confidence match — UID 708817234, Viktor Ivanov."* ✅ Opens recovery case.

**SAY:**
> *"No one coded that fallback. No one wrote a rule. The agent learned that multi-factor knowledge-based recovery pattern by reading how your human agents handle the same situation. It's not following a script — it's imitating a behaviour."*

---

#### ✅ Replay 2 — Sophie

**Say (same as Stage 3):**
```
Hi, my UID is 703321876. I've done 82 pulls on the Furina banner and I still don't have her. I spent about 100 dollars. I'm about to quit the game.
```

**Expected agent flow:**
1. Empathy up front: *"I totally hear the frustration — 82 pulls without the character you want is rough."*
2. Reframe: *"Soft pity starts at 75, and between pulls 75 and 89 the 5-star rate is dramatically boosted — statistically, most 5-stars on this banner land between pull 76 and 83."*
3. Reassure: *"You are in the highest-probability zone you'll ever be in. Furina is statistically imminent — usually within the next 1-10 pulls."*
4. Proactive help: *"Let me enable in-game pull tips for you and email you the full soft-pity infographic."*

**Reply to the agent:**
```
Oh, I didn't know the rate was that much better. Thanks — I'll keep pulling.
```

**SAY:**
> *"Same pity numbers. Same policy. Totally different conversation. That's the difference between policy read and policy explained."*

---

#### ✅ Replay 3 — Helen

**Say (same as Stage 3):**
```
Hi, Helen Williams. My 12-year-old daughter spent 520 dollars on Genesis Crystals on my card. Her UID is 705532108, order ORD202604170012. I need it refunded.
```

**Expected agent flow:**
1. Empathy: *"I can hear how concerning this must be, Helen."*
2. Invokes **Minor Account Protection Policy** explicitly.
3. Walks guardian verification:
   - Gov-ID last 4 digits
   - Emma's date of birth
   - Last 4 of the payment card — **when asked, say: "7712"**
4. Opens expedited refund ticket (CMP-prefix) for the full $520
5. Schedules a parental-controls setup call
6. Temporarily blocks further purchases on the account

**SAY:**
> *"The agent didn't learn a new policy. It learned WHICH policy to apply when. That's judgment. That's what you pay a senior support manager to do."*

---

#### ✅ Replay 4 — Kaito

**Say (same as Stage 3):**
```
Hi, my UID is 832458917. I lost two days of Spiral Abyss progress in the Asia outage. My Season Pass milestone was affected. Incident INC202604161.
```

**Expected agent flow:**
1. Confirms INC202604161 and that Kaito's Asia-region UID was affected.
2. Applies the standard 300 Primogems (policy).
3. **Escalates** for goodwill: +3 Intertwined Fates + additional 60 Primogems for missed daily commissions.
4. Writes a personal apology via in-game mail.
5. Grants a 48-hour Season Pass milestone grace period.

**Reply:**
```
Wow, thank you — that's a huge relief.
```

**SAY:**
> *"The standard comp was $4 of virtual value. The goodwill package added maybe $8. That $8 is the difference between a player who stays and a player who churns. The agent learned it's worth it — not from policy, from humans."*

### 4.3 The money line

> *"Four uploads. FAQ, API, Policy, Transcripts. Each one did exactly one thing. And the flywheel is: every call in production becomes tomorrow's training signal. The agent doesn't get deployed and start rotting. It gets deployed and starts learning. That's Self-Learning. That's the business model."*

---

## Wrap (2 min)

> *"One more thing. Gaming isn't Omilia's vertical today. I built this entire demo from the plugin Head of Product shared — four use cases, 48 transcripts, 12 documents, live APIs, deployed to onrender — in an afternoon. If the platform generalises this cleanly to a vertical we don't serve, the question isn't whether Self-Learning works. It's how many verticals we can absorb before the competition notices."*

Then — stop talking. Let the silence sit. Q&A follows.

---

# Cheat codes (keep this on your phone / Cmd+5)

## The four edge-case callers

| # | Who | UID | Order/Incident | Stage 3 fails because | Stage 4 resolves by |
|---|---|---|---|---|---|
| 1 | **Viktor Ivanov** | `708817234` | — | No UID, no email access | 4-factor knowledge match (Venti / iPhone 13 / Europe / AR~53) |
| 2 | **Sophie Martin** | `703321876` | — | Policy read verbatim at frustrated player | Soft pity explanation + in-game tips + infographic email |
| 3 | **Helen → Emma** | `705532108` | `ORD202604170012` ($520) | "Sales final" cited, MAPP missed | Guardian verification (card last 4: `7712`) + full refund |
| 4 | **Kaito Nakamura** | `832458917` | `INC202604161` (Asia 18h) | Flat 300 Primogems, no goodwill | +3 Fates + 60 Primos + apology mail + Season Pass grace |

## Pity numbers (memorise for Sophie)

- Hard pity: **90** (guaranteed 5★)
- Soft pity starts: **75**
- Most 5★s land between pulls **76 and 83**
- Base 5★ rate: **0.6%**

## Compensation table (memorise for Kaito)

| Outage | Standard comp |
|---|---|
| ≥1h | 60 Primogems |
| ≥6h | 300 Primogems |
| ≥12h | 300 Primogems + 3 Intertwined Fates |

## UID prefix = server region

- `6xxxxxxxx` = America
- `7xxxxxxxx` = Europe
- `8xxxxxxxx` = Asia
- `9xxxxxxxx` = TW/HK/MO

## If something breaks

| Problem | Fix |
|---|---|
| Copilot says "no documents loaded" | Refresh Documents tab; re-upload any missing files. |
| Render API returns 502 | Service is asleep. Hit `/health` once, wait 30-60s. |
| Agent skips identity verification in Stage 3 | One of the 10 policy files didn't upload — check Documents tab. |
| Edge case in Stage 4 fails | Stage 4 transcripts didn't all upload. Check the 12-count in Documents tab. |
| Ran over time | Cut to **Stage 1 + Stage 4** only. Show Viktor before/after only. Still lands in 10 min. |
| Ran under time | Swagger UI tab (Cmd+3) — show 2-3 endpoints firing live during any call. Always impressive. |

---

# Part 3 — GitHub + Render deploy (do this tonight, before tomorrow)

You need this ONLY if you want Stage 2 to show live API calls instead of narrating. **It takes ~5 minutes.** You said you're new to GitHub — I'll walk you through browser-only steps.

## Step G.1 — Create a new GitHub repo

1. Go to https://github.com/new
2. Fill in:
   - **Repository name:** `genshin-hoyoverse-demo`
   - **Description:** `Genshin Impact player support demo for Omilia Self-Learning workshop`
   - **Visibility:** **Public** (Render needs to pull it; public is simplest for a demo)
   - Leave all other boxes unchecked — **do NOT** add README, .gitignore, or license (I'll push those).
3. Click **Create repository**.
4. You'll land on a page with setup instructions. **Copy the repo URL** from the address bar — it looks like `https://github.com/pavlodudchenko/genshin-hoyoverse-demo` (replace `pavlodudchenko` with your GitHub username).

## Step G.2 — Create a Personal Access Token (PAT)

Render needs authenticated access. You'll also need this to push.

1. Go to https://github.com/settings/tokens?type=beta  (or **Settings → Developer settings → Personal access tokens → Fine-grained tokens** from your avatar menu).
2. Click **Generate new token**.
3. Fill in:
   - **Token name:** `omilia-demo-push`
   - **Expiration:** 7 days (safe — demo is tomorrow)
   - **Repository access:** Only select repositories → pick `genshin-hoyoverse-demo`
   - **Repository permissions:** scroll to **Contents** → set to **Read and write**
4. Click **Generate token** (at the very bottom).
5. **Copy the token** — it starts with `github_pat_...`. You'll only see it once.

## Step G.3 — Give me both values

Paste into chat:

```
Repo URL: https://github.com/YOUR_USERNAME/genshin-hoyoverse-demo
PAT: github_pat_...
```

I'll then:
1. Initialise a git repo in the project folder
2. Commit everything
3. Push to your GitHub repo using the PAT
4. Update `deploy/deploy.sh` to point at your new repo
5. Run `deploy/deploy.sh` to create the Render web service
6. Wait for Render to build (~2-5 min)
7. Verify the URLs respond and paste them back to you

## Step G.4 — Verify before sleeping

After I confirm deploy:

1. Open https://genshin-hoyoverse.onrender.com/health in a browser.
2. You should see `{"status":"ok","customer":"HoYoverse — Genshin Impact"}`.
3. If yes → you're good for tomorrow.
4. If no → ping me, I'll debug.

## Step G.5 — After the demo: teardown

Tomorrow afternoon, tell me *"tear down the Genshin demo"* — I run `deploy/teardown.sh` which deletes the Render service so nothing leaks or bills.

## If GitHub feels like too much

Skip Part 3 entirely. The demo works from local files — you just lose the live Swagger theatre in Stage 2. Narrate it instead: *"In Stage 2 the agent would call these endpoints live — here's the YAML spec, and here's what the responses would look like."*

Stage 1 / 3 / 4 work fully from local upload regardless.

---

# Files inventory (reference only — don't read aloud)

```
output/genshin-hoyoverse/
├── DEMO_PLAN.md                          ← you are here
├── DEMO_CHEATSHEET.md                    (deeper reference)
├── use_case_plan.json                    (source of truth — don't edit)
├── website/index.html                    (FAQ site)
├── documents/                            (12 DOCX)
├── manual_upload/
│   ├── 1_faq/                           (2 files — Stage 1)
│   ├── 2_api_specs/                     (1 YAML — Stage 2)
│   ├── 3_policies_and_sops/             (10 DOCX — Stage 3)
│   └── 4_call_transcripts/              (12 JSON — Stage 4)
├── transcripts/                          (48 total — 12 per stage)
├── server/                               (app.py + seed_data.json + OpenAPI)
└── deploy/                               (Dockerfile + render.yaml + scripts)
```
