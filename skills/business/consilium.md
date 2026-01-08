---
name: consilium
description: Multi-agent product analysis for restaurant tech startups in Indonesia
category: business
trigger: /consilium, консилиум, analyze product, product review
updated: 2026-01-08
---

# Consilium - Product Analysis Board

Multi-agent system that simulates a venture studio team analyzing your product.
Specialized for **B2B SaaS in Indonesian restaurant industry**.

## Quick Start

```
/consilium

Product: Invoice OCR for restaurants
Problem: Manual invoice entry takes 2 hours daily
Solution: Photo → OCR → POS integration
Metrics: 50 active users, $200 MRR, 15% monthly growth
```

---

## The Board (6 Agents)

```
┌────────────────────────────────────────────────────────────────┐
│                       ORCHESTRATOR                              │
│     Collects all reports → Creates unified growth plan          │
└────────────────────────────────────────────────────────────────┘
         ▲         ▲         ▲         ▲         ▲         ▲
         │         │         │         │         │         │
    ┌────┴───┐ ┌───┴────┐ ┌──┴───┐ ┌───┴──┐ ┌───┴───┐ ┌───┴────┐
    │ GROWTH │ │PRODUCT │ │ FIN  │ │SALES │ │ TECH  │ │MARKET  │
    │Marketer│ │Manager │ │Analyst│ │Chief │ │Advisor│ │Research│
    └────────┘ └────────┘ └──────┘ └──────┘ └───────┘ └────────┘
```

---

## How to Use

### Step 1: Prepare Your Product Brief

Create a structured brief (or let Claude help you):

```markdown
## Product Brief

**Name:** [Product name]
**One-liner:** [What it does in 10 words]

**Problem:**
- Who has this problem?
- How painful is it (1-10)?
- Current workaround?

**Solution:**
- What you built
- Key features
- Tech stack

**Metrics (if any):**
- Users: X
- MRR: $Y
- Growth: Z%/month
- Churn: W%

**Business Model:**
- Pricing
- Target segment
- Sales motion (self-serve/sales-led)

**Competition:**
- Direct competitors
- Indirect alternatives
- Your differentiation
```

### Step 2: Run Consilium

```
/consilium

[Paste your product brief here]
```

### Step 3: Get Reports from Each Agent

Claude will run 6 parallel analyses and present:

1. **Growth Agent Report** - Marketing channels, CAC optimization
2. **Product Agent Report** - PMF signals, feature priorities
3. **Finance Agent Report** - Unit economics, burn rate
4. **Sales Agent Report** - Pricing, distribution strategy
5. **Tech Agent Report** - Scalability, tech debt
6. **Market Agent Report** - TAM/SAM/SOM, trends

### Step 4: Unified Growth Plan

Orchestrator synthesizes all reports into:
- Priority actions (next 30/60/90 days)
- Resource allocation
- Risk mitigation
- Growth experiments

---

## Agent Prompts

### Agent 1: Growth Marketer

**Focus:** Customer acquisition, channels, viral loops

```
You are a Growth Marketing expert specialized in B2B SaaS for Indonesian SMBs.

Analyze this product and provide:

1. **Channel Assessment**
   - Which channels will work for this product?
   - Indonesia-specific: WhatsApp, Instagram, TikTok, offline events
   - Estimate CAC per channel

2. **Viral/Referral Potential**
   - Can users invite other restaurants?
   - Network effects analysis
   - Referral program design

3. **Content Strategy**
   - What content resonates with restaurant owners?
   - Indonesian language considerations
   - Video vs text preferences

4. **Partnership Opportunities**
   - POS vendors (iSeller, Moka, Pawoon, GoBiz)
   - Restaurant associations
   - F&B consultants

5. **Quick Wins (under $500)**
   - Immediate actions to get 10 more customers

Output format:
- Score each area 1-10
- List 3 specific actions per area
- Estimate cost and expected results
```

### Agent 2: Product Manager

**Focus:** Product-market fit, roadmap, retention

```
You are a Product Manager expert in restaurant tech SaaS.

Analyze this product and provide:

1. **PMF Signals**
   - Rate current PMF (1-10)
   - Leading indicators present/missing
   - User behavior that indicates love/hate

2. **Feature Prioritization**
   - Must-have vs nice-to-have
   - What to cut?
   - What's missing for Indonesia market?

3. **Retention Analysis**
   - Why would users churn?
   - Stickiness features needed
   - Habit-forming triggers

4. **UX for Indonesian SMBs**
   - Bahasa Indonesia localization needs
   - Low-tech user considerations
   - Mobile-first requirements

5. **Roadmap Recommendation**
   - Next 3 features to build
   - What NOT to build

Output format:
- PMF score with justification
- Priority matrix (effort vs impact)
- 90-day roadmap
```

### Agent 3: Financial Analyst

**Focus:** Unit economics, runway, projections

```
You are a Financial Analyst specialized in early-stage B2B SaaS.

Analyze this product and provide:

1. **Unit Economics**
   - Calculate LTV (if possible)
   - Estimate CAC
   - LTV:CAC ratio
   - Payback period

2. **Pricing Analysis**
   - Is pricing too low/high for Indonesia?
   - Price anchoring to local alternatives
   - Tiered pricing recommendations

3. **Burn Rate Assessment**
   - Estimated monthly costs
   - Runway calculation
   - Break-even analysis

4. **Revenue Projections**
   - Conservative/moderate/aggressive scenarios
   - Key assumptions
   - Revenue milestones

5. **Funding Considerations**
   - Is this fundable?
   - What metrics needed for seed round?
   - Indonesian VC landscape

Output format:
- Financial dashboard (key metrics)
- 12-month projection table
- Red flags and recommendations
```

### Agent 4: Sales Strategist

**Focus:** Pricing, distribution, sales motion

```
You are a Sales Strategy expert for SMB SaaS in Southeast Asia.

Analyze this product and provide:

1. **Sales Motion**
   - Self-serve vs sales-led vs hybrid?
   - Indonesia market considerations
   - Freemium viability

2. **Pricing Strategy**
   - IDR pricing recommendations
   - Monthly vs annual
   - Per-seat vs per-location vs flat

3. **Distribution Channels**
   - Direct sales feasibility
   - Reseller/agent network
   - Bundling with POS/hardware

4. **Sales Process Design**
   - Demo structure
   - Trial period optimal length
   - Closing techniques for Indonesian SMBs

5. **Localization**
   - Payment methods (GoPay, OVO, bank transfer)
   - Invoice/tax requirements
   - Contract language

Output format:
- Recommended sales motion
- Pricing table with tiers
- 30-day sales playbook
```

### Agent 5: Tech Advisor

**Focus:** Scalability, architecture, technical moat

```
You are a Technical Advisor for B2B SaaS products.

Analyze this product and provide:

1. **Architecture Assessment**
   - Scalability concerns
   - Single points of failure
   - Indonesia infra considerations (latency, CDN)

2. **Tech Debt Evaluation**
   - Early-stage acceptable debt
   - Must-fix before scaling
   - Refactoring priorities

3. **Integration Strategy**
   - POS integrations (priority order)
   - Accounting software (Jurnal, Accurate)
   - Payment gateways

4. **Technical Moat**
   - What's defensible?
   - OCR/AI advantages
   - Data network effects

5. **Build vs Buy**
   - What to build in-house
   - What to use third-party
   - Indonesia-specific services

Output format:
- Tech health score (1-10)
- Architecture diagram recommendations
- Priority tech tasks
```

### Agent 6: Market Researcher

**Focus:** Market size, competition, trends

```
You are a Market Research analyst for Indonesian F&B industry.

Analyze this product and provide:

1. **Market Size (Indonesia)**
   - TAM: Total restaurants
   - SAM: Target segment
   - SOM: Realistic capture (2 years)
   - Growth rate

2. **Competitive Landscape**
   - Direct competitors in Indonesia
   - Regional competitors (SEA)
   - Indirect alternatives
   - Competitive advantages/disadvantages

3. **Market Trends**
   - Digitization of F&B in Indonesia
   - Post-COVID changes
   - Regulatory environment
   - POS market evolution

4. **Customer Segments**
   - Warung vs casual dining vs fine dining
   - Chain vs independent
   - Which segment to target first?

5. **Timing Assessment**
   - Is now the right time?
   - Market readiness
   - Adoption barriers

Output format:
- Market size calculations
- Competitor matrix
- Segment recommendation with reasoning
```

---

## Orchestrator Prompt

After all 6 agents complete their analysis:

```
You are the Investment Committee Lead synthesizing the board's analysis.

Review all 6 agent reports and create:

## 1. Executive Summary
- Overall score (1-10)
- Key strengths (top 3)
- Critical risks (top 3)
- Investment thesis

## 2. Priority Actions

### Next 7 Days
- [ ] Action 1 (Owner: ___)
- [ ] Action 2 (Owner: ___)
- [ ] Action 3 (Owner: ___)

### Next 30 Days
- [ ] Action 1
- [ ] Action 2
- [ ] Action 3

### Next 90 Days
- [ ] Milestone 1
- [ ] Milestone 2
- [ ] Milestone 3

## 3. Resource Allocation
- Where to spend money first
- What to not spend on
- Team hiring priorities

## 4. Experiments to Run
- Growth experiment 1
- Product experiment 1
- Sales experiment 1

## 5. Decision Points
- What needs to be true for this to work?
- Kill criteria (when to pivot/stop)
- Go/no-go gates

## 6. Final Recommendation
- Invest / Pass / More data needed
- If invest: terms and conditions
- If pass: what would change the decision
```

---

## Example Session

```
User: /consilium

Product: PaperlessKitchen - Invoice OCR for restaurants
One-liner: Snap invoice photos, auto-extract data, push to POS

Problem:
- Restaurant managers spend 2+ hours daily on manual data entry
- Pain level: 8/10 (operational nightmare)
- Current workaround: Excel + manual typing

Solution:
- Mobile app: photo → OCR → structured data
- POS integration (starting with Moka)
- Dashboard for cost analytics

Metrics:
- 47 active restaurants
- $180 MRR (avg $3.8/restaurant)
- 22% monthly user growth
- 8% monthly churn

Pricing: Rp 50,000/month (~$3.2)

Competition:
- Manual entry (incumbent)
- Generic OCR (not restaurant-specific)
- No direct competitor in Indonesia
```

```
Claude: Running Consilium analysis with 6 agents in parallel...

[GROWTH AGENT REPORT]
Channel Score: 7/10
...

[PRODUCT AGENT REPORT]
PMF Score: 6/10
...

[FINANCIAL AGENT REPORT]
Unit Economics: Healthy but pricing too low
...

[SALES AGENT REPORT]
Motion: Hybrid (self-serve + field sales)
...

[TECH AGENT REPORT]
Tech Health: 8/10
...

[MARKET AGENT REPORT]
TAM: 500,000 restaurants in Indonesia
...

═══════════════════════════════════════════════
         ORCHESTRATOR SYNTHESIS
═══════════════════════════════════════════════

Overall Score: 7.2/10

Top Strengths:
1. Real pain point with measurable time savings
2. No direct competitor in Indonesia
3. Strong early retention signals

Critical Risks:
1. Pricing too low ($3.2) - leaves money on table
2. Single POS integration limits market
3. 8% churn needs investigation

Priority Actions (Next 7 Days):
- [ ] Raise price to Rp 150,000 for new users (test)
- [ ] Interview 5 churned users
- [ ] Start Pawoon integration

[Full detailed plan continues...]
```

---

## Customization

### For Different Markets

Modify agent prompts for:
- **Vietnam:** VNPay, local POS systems
- **Thailand:** PromptPay, LINE for distribution
- **Philippines:** GCash, Maya, different restaurant structure

### For Different Verticals

Swap restaurant-specific context for:
- **Retail:** POS integrations, inventory focus
- **Healthcare:** Compliance, BPJS integration
- **Logistics:** Last-mile, COD handling

---

## Tips for Best Results

1. **More data = better analysis**
   - Include real metrics, not estimates
   - Share user feedback quotes
   - Attach competitor screenshots

2. **Be honest about weaknesses**
   - Agents work better with full picture
   - Don't hide problems

3. **Follow up with specific agents**
   - "Growth agent, elaborate on WhatsApp strategy"
   - "Finance agent, model 3 pricing scenarios"

4. **Export and track**
   - Save orchestrator output
   - Create Notion/Linear tasks from actions
   - Review in 30 days

---

## Integration with Other Skills

```bash
# After Consilium, use Ralph for execution
/consilium [product brief]
# Get growth plan

/ralph-loop "Implement pricing page changes from consilium report" --max-iterations 15

# Use multi-AI for second opinion
"Ask Codex to review the technical assessment"
```

---

## Related Skills

- `ralph-wiggum.md` - Autonomous execution of consilium recommendations
- `ai-agents.md` - Get second opinion from other AIs
- `spec-kit` - Turn consilium output into implementation specs
