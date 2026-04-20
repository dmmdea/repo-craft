> **Consult this if:** planning first contact with a maintainer — matching their review tone, response cadence, explicit welcomed/rejected signals.
>
> **Cross-refs:** [02](./02-contribution.md) · [06](./06-archaeology-author.md) · [08](./08-influence.md)

## Table of Contents

- [Evan You Vue Vite](#evan-you-vue-vite)
- [Rich Harris Svelte](#rich-harris-svelte)
- [Sindre Sorhus](#sindre-sorhus)
- [Anthony Fu](#anthony-fu)
- [Fabien Potencier Symfony](#fabien-potencier-symfony)
- [Matz Ruby](#matz-ruby)
- [Linus Torvalds Linux kernel](#linus-torvalds-linux-kernel)
- [Daniel Stenberg curl](#daniel-stenberg-curl)
- [Pattern Meta-Analysis](#pattern-meta-analysis)

---

# Maintainer Profiles: Citable Case Studies for `repo-craft`

## How to use this reference

The `repo-craft` skill helps contributors align their issues, PRs, and proposals with how a specific maintainer actually thinks. Reading `CONTRIBUTING.md` is table stakes; what separates a fast-merged PR from a `wontfix` is almost always fit with the maintainer's operating model — what they value, what tone they use in review, how they handle scope creep, and what they publicly celebrate.

The profiles below cover eight maintainers across four governance archetypes: solo BDFL, solo BDFL turned employed (but still autonomous), corporate-employed core contributor, foundation-governed dictator-for-life, and protocol/spec author. Each profile is strictly sourced from public, professional behavior — writing, talks, interviews, and public repo activity — with URLs for every factual claim. No gossip, no resolved-controversy retread, no personal-life material.

Use these as exemplars when drafting a contribution strategy for any maintainer whose profile the skill has not yet catalogued. At the end of the document, a **Pattern meta-analysis** extracts cross-cutting rules you can apply when you have never heard of the person on the other side of the PR.

---

## Evan You Vue Vite

**Identity.** Evan You is creator of [Vue.js](https://vuejs.org/) and [Vite](https://vitejs.dev/), and founded [VoidZero Inc.](https://voidzero.dev/) in 2024 to sustain Vite and the adjacent toolchain. He previously worked as a full-time independent open source developer funded by Patreon and corporate sponsors beginning 2016 ([GitHub Readme Stories](https://github.com/readme/stories/evan-you); [Maintainers Anonymous interview](https://maintainersanonymous.com/freedom/)).

**Public posture.** Personal site [evanyou.me](https://evanyou.me/); X at [@youyuxi](https://x.com/youyuxi). Canonical talks: ["Design Principles of Vue 3.0"](https://www.youtube.com/watch?v=WLpLYhnGqPA) and the [GitHub Readme podcast](https://github.com/readme/podcast/growing-vue). The [CoRecursive podcast "From 486 to Vue.js"](https://corecursive.com/vue-with-evan-you/) is a good longer-form posture piece.

**Philosophy.** (1) *Progressive adoption over total conversion* — Vue's core pitch that you can adopt it incrementally ([Vue.js guide intro](https://vuejs.org/guide/introduction.html)). (2) *Stability of the ecosystem outranks novelty* — Evan has said Vue 3 code should still work 5–10 years from now, and there is no Vue 4 planned ([GitHub Readme Stories](https://github.com/readme/stories/evan-you)). (3) *Feature additions require RFCs* because Vue is at a stage where the team consciously prevents further API-surface complexity ([vuejs/rfcs README](https://github.com/vuejs/rfcs/blob/master/README.md)). (4) *Design starts with desired UX, works backwards to the abstraction* — a principle he shares with the React team approach.

**Contribution signals he welcomes.** Well-scoped bug reports with reproductions in the official [repro stackblitz](https://github.com/vuejs/core/blob/main/.github/contributing.md); RFCs that cite prior art from Rust, React, or Ember RFCs; pull requests that keep the core small and push complexity into plugins ([vuejs/core contributing guide](https://github.com/vuejs/core/blob/main/.github/contributing.md)).

**Contribution signals he rejects.** "Substantial" changes submitted as PRs rather than RFC discussions; anything that widens the core API surface without clear user-facing motivation; churn on stable APIs.

**Review tone.** Terse, technical, friendly. Evan's comments on [vuejs/core](https://github.com/vuejs/core/pulls?q=is%3Apr+commenter%3Ayyx990803+) tend to be short, direct, and focused on API shape rather than code style. He defers style to automated tooling.

**Response cadence.** Active daily on GitHub, timezone typically US Pacific / occasional Asia travel. Response to well-formed issues is often within 24–48 hours; RFCs may sit for weeks awaiting core-team sync.

**Fit notes.** If you want to contribute to Vue core or Vite: open an RFC discussion *before* a PR for anything non-trivial, link a minimal repro for bugs, and keep the patch surgical. Avoid proposals that expand the ergonomic API without clear user data; avoid "why not do X like React" framings.

---

## Rich Harris Svelte

**Identity.** Creator of [Svelte](https://svelte.dev/) and SvelteKit. Joined Vercel in 2021 to work on Svelte full-time ([Vercel "Future of Svelte" interview](https://vercel.com/blog/the-future-of-svelte-an-interview-with-rich-harris)). Governance model: Rich is project lead; Vercel sponsors the work but the project is community-governed.

**Public posture.** X at [@Rich_Harris](https://x.com/Rich_Harris); canonical essays ["Write Less Code"](https://svelte.dev/blog/write-less-code) and ["Frameworks without the framework"](https://svelte.dev/blog/frameworks-without-the-framework). Representative talks: ["Rethinking reactivity"](https://www.youtube.com/watch?v=AdNJ3fydeao) and ["How to make a great framework better? — Svelte 5"](https://www.youtube.com/watch?v=z7n17ajJpCo).

**Philosophy.** (1) *Write less code* — a React component is typically 40% larger than its Svelte equivalent, and the compiler approach exists precisely to shrink the author's surface area ([svelte.dev blog](https://svelte.dev/blog/write-less-code)). (2) *Frameworks are tools for organising your mind, not your code* (["Rethinking reactivity"](https://www.youtube.com/watch?v=AdNJ3fydeao)). (3) *Coherent philosophical worldview matters more than feature parity* — projects need to be moving in a direction ([Scott Logic "Philosophy of Svelte"](https://blog.scottlogic.com/2021/01/18/philosophy-of-svelte.html)). (4) The Svelte [Tenets discussion](https://github.com/sveltejs/svelte/discussions/10085) is the canonical statement of what the project will and won't do.

**Contribution signals he welcomes.** Bug reports with minimal REPL repros; perf improvements backed by benchmarks; PRs that *reduce* authoring surface area; thoughtful challenges to existing design with runnable comparisons.

**Contribution signals he rejects.** "Please add TypeScript to compiler internals" style re-litigation of tenet-level decisions ([Issue #16647](https://github.com/sveltejs/svelte/issues/16647)); feature-parity-with-React framing without independent justification; demands that Svelte match another framework's idioms.

**Review tone.** Discursive and discursive-polite. Rich explains *why* he disagrees rather than just closing. He will author a long comment rather than a one-liner.

**Response cadence.** Active weekly on sveltejs/svelte. UK timezone; weekend activity exists but is not guaranteed. Complex discussions often wait for a core-team sync.

**Fit notes.** Lead with "here is a smaller authoring experience" framing. Bench your claims. Read the [Tenets](https://github.com/sveltejs/svelte/discussions/10085) before proposing anything structural. Don't argue by analogy to React unless the analogy genuinely clarifies.

---

## Sindre Sorhus

**Identity.** Full-time open source developer, funded entirely by [GitHub Sponsors / Open Collective / Patreon](https://opencollective.com/sindresorhus). Maintains 1,100+ npm packages producing well over 1 billion downloads/month ([freeCodeCamp interview](https://www.freecodecamp.org/news/sindre-sorhus-8426c0ed785d/)).

**Public posture.** Blog at [sindresorhus.com/blog](https://sindresorhus.com/blog); GitHub profile [@sindresorhus](https://github.com/sindresorhus). Representative writing: the interview above, and the [ESM move discussion](https://github.com/sindresorhus/meta/discussions/15) where he documents the push to ESM-only modules.

**Philosophy.** (1) *Small modules improve focus, comprehensibility, and reusability* — "scoping things tightly reduces the cognitive load… it also makes it more likely that the module can be reused and composed in ways the original author didn't anticipate" ([freeCodeCamp interview](https://www.freecodecamp.org/news/sindre-sorhus-8426c0ed785d/)). (2) *ESM is the future; CJS support is not his job anymore* ([sindresorhus/meta #15](https://github.com/sindresorhus/meta/discussions/15)). (3) *Boundaries protect sustainability* — he explicitly describes an early period of merging PRs within minutes and responding at all hours leading to burnout ([freeCodeCamp interview](https://www.freecodecamp.org/news/sindre-sorhus-8426c0ed785d/)). (4) *Open source should be enjoyable, not a source of stress*.

**Contribution signals he welcomes.** Tiny, surgical PRs that match an existing package's stated scope; docs fixes; tests for edge cases; contributions to the [Awesome](https://github.com/sindresorhus/awesome) lists that follow the strict template.

**Contribution signals he rejects.** Feature requests that expand a module beyond "one thing well"; requests to support CommonJS alongside ESM in his newer modules; long discussion threads — he will lock and close.

**Review tone.** Terse, templated, polite-but-final. He uses [saved replies](https://docs.github.com/en/get-started/writing-on-github/working-with-saved-replies) heavily to close off-scope requests consistently.

**Response cadence.** Cadence is deliberately throttled — he has publicly said he only prioritizes his top ~10 projects. Others may get weeks-to-never. CET timezone.

**Fit notes.** Read the package README scope sentence *first*. If your request is not inside that sentence, make a new module instead of proposing an addition. Keep PRs small, test-covered, ESM-native. Do not argue when closed; open a separate module.

---

## Anthony Fu

**Identity.** Creator of [VueUse](https://vueuse.org/), [UnoCSS](https://unocss.dev/), [Vitest](https://vitest.dev/), [Slidev](https://sli.dev/), [Elk](https://elk.zone/), [Type Challenges](https://tsch.js.org/); core member of Vue, Nuxt, Vite. Funded via [GitHub Sponsors](https://github.com/sponsors/antfu) and employment at NuxtLabs/Vercel. He redistributes some sponsorship to upstream dependencies ([Anthony Fu Fund](https://opencollective.com/antfu)).

**Public posture.** Blog at [antfu.me](https://antfu.me/); Bluesky [@antfu.me](https://bsky.app/profile/antfu.me). Canonical talks: ["Anthony's Roads to Open Source — The Set Theory"](https://www.youtube.com/watch?v=NJbCfAKtxUI) (ViteConf 2023) and ["The Progressive Path"](https://www.youtube.com/watch?v=w98pzqZt7S0) (ViteConf 2024). Key personal essay: ["Mental Health in Open Source"](https://antfu.me/posts/mental-health-oss).

**Philosophy.** (1) *Set theory of open source* — build Set Intersection (solve a niche well) and Set Union (make tooling universal so it lifts the whole ecosystem) ([GitNation talk page](https://gitnation.com/contents/anthonys-roads-to-open-source-the-set-theory)). (2) *Ask for nothing* — participate in OSS without putting benefits first; focus on craft and sharing ([ViteConf 2023](https://www.youtube.com/watch?v=NJbCfAKtxUI)). (3) *Progressive design* — start scratchy and iterate toward shape. (4) *Redistribute sponsorship upstream* — dependencies deserve support too.

**Contribution signals he welcomes.** Small tools and utilities, composable abstractions, PRs that make something universal (Set Union), playful experiments that fit the aesthetic of his projects, contributions across his many repos (he rewards breadth).

**Contribution signals he rejects.** Demands, entitled bug reports, pressure to prioritize. See his [Mental Health in Open Source](https://antfu.me/posts/mental-health-oss) post on how entitlement erodes maintainer capacity.

**Review tone.** Mentor-polite, warm, encouraging. He will often refactor a contributor's PR in a follow-up commit rather than close it.

**Response cadence.** Prolific across ~20 repos; Shanghai / Europe timezone. First response often same-day for core projects, slower for long-tail repos. Weekends are active.

**Fit notes.** Pattern your PR after his aesthetic: small, composable, fun. Credit upstream. Never frame requests as demands. Contributing to a *less-famous* Antfu repo is often a higher-signal way to earn review attention than piling onto Vitest.

---

## Fabien Potencier Symfony

**Identity.** Founded Symfony in 2004; founder of Twig and [PHP-CS-Fixer](https://cs.symfony.com/). Currently runs Symfony SAS and remains project lead ([Symfony Contributors page](https://symfony.com/contributors)). GitHub [@fabpot](https://github.com/fabpot).

**Public posture.** Blog at [fabien.potencier.org](https://fabien.potencier.org/); X at [@fabpot](https://x.com/fabpot). Canonical essay: ["About Symfony: Stability over Features"](https://fabien.potencier.org/about-symfony-stability-over-features.html) and ["Why Symfony?"](https://fabien.potencier.org/why-symfony.html).

**Philosophy.** (1) *Stability over features* — "backward compatibility and stability are more important than everything else" ([Stability over Features](https://fabien.potencier.org/about-symfony-stability-over-features.html)). (2) *Formal BC promise* — Symfony has a documented [Backward Compatibility Promise](https://symfony.com/doc/current/contributing/code/bc.html) that constrains what can change in minor releases. (3) *Don't reinvent the wheel* — tight integration with other OSS rather than NIH ([Why Symfony?](https://fabien.potencier.org/why-symfony.html)). (4) *Predictable release train* — Symfony ships on a published schedule (two minors and one LTS per year).

**Contribution signals he welcomes.** PRs that respect the BC promise; deprecations that follow the formal path (trigger_deprecation → major release removal); documentation PRs; bundle maintainers who adhere to Symfony coding standards.

**Contribution signals he rejects.** Anything breaking BC in a minor; large architectural proposals without RFC discussion on [symfony/symfony](https://github.com/symfony/symfony); "rewrite this component in a different style" PRs.

**Review tone.** Terse, gatekeeper-serious. Fabien's comments tend to be short: approve, request change, or close-with-reason.

**Response cadence.** Very active on [symfony/symfony](https://github.com/symfony/symfony) PRs; CET timezone. Merges and reviews happen on a nearly-daily cadence; the pipeline is structured around release schedules.

**Fit notes.** Read the [Backward Compatibility Promise](https://symfony.com/doc/current/contributing/code/bc.html) before proposing anything. Use `trigger_deprecation` for any removal. Follow Symfony coding standards exactly (run PHP-CS-Fixer). For substantive changes, open a discussion on the mailing list or issue tracker before the PR.

---

## Matz Ruby

**Identity.** Creator of Ruby (1995). Chief designer; final word on language design via the [Ruby core](https://www.ruby-lang.org/en/community/ruby-core/) team and the [Ruby Issue Tracking System](https://bugs.ruby-lang.org/). Employed historically by Heroku and more recently by [NaCl](https://www.netlab.jp/).

**Public posture.** GitHub [@matz](https://github.com/matz); X at [@yukihiro_matz](https://x.com/yukihiro_matz). Canonical interview: [Artima "The Philosophy of Ruby"](https://www.artima.com/articles/the-philosophy-of-ruby); and the [Heroku Ruby 2.3 conversation](https://www.heroku.com/blog/ruby-2-3-0-on-heroku-with-matz/).

**Philosophy.** (1) *Developer happiness is the design goal* — "I want to make Ruby users free. I want to give them the freedom to choose" ([Artima](https://www.artima.com/articles/the-philosophy-of-ruby)). (2) *MINASWAN — Matz Is Nice And So We Are Nice* — the community's codified tone, which Matz has endorsed as how he wants discussion to work ([Wikipedia: Yukihiro Matsumoto](https://en.wikipedia.org/wiki/Yukihiro_Matsumoto)). (3) *Breaking changes require strong justification* — Ruby's 2.x→3 transition was designed for near-total compatibility; incompatible changes "must be provided with a reasonable reason" ([Heroku interview](https://www.heroku.com/blog/ruby-2-3-0-on-heroku-with-matz/)). (4) *There's more than one way* — inherited Perl sensibility.

**Contribution signals he welcomes.** Proposals submitted to the [Ruby Issue Tracking System](https://bugs.ruby-lang.org/) with clear motivation; patches with tests; discussions at RubyKaigi/developer meetings where Matz can weigh in.

**Contribution signals he rejects.** Spray-everywhere style PRs (e.g., the Rails-era proposal to add `.freeze` everywhere was met with Matz's team finding it "ugly" and introducing the [`frozen_string_literal` magic comment](https://docs.ruby-lang.org/en/3.2/syntax/comments_rdoc.html) instead). Proposals that trade aesthetics for theoretical gain.

**Review tone.** Mentor; quiet; final. Matz rarely argues at length on the tracker — he defers to core committers on mechanics and weighs in decisively on language aesthetics.

**Response cadence.** Japan timezone. Language-design decisions often wait for the monthly [developer meeting](https://github.com/ruby/dev-meeting-log) and are summarized publicly afterward. Implementation PRs are handled by core committers.

**Fit notes.** Frame proposals around *developer happiness and readability*. File on the bugtracker, not just GitHub. Attend or follow the dev-meeting log before lobbying. Respect MINASWAN — the Ruby community enforces tone, and terse-angry doesn't travel here.

---

## Linus Torvalds Linux kernel

**Identity.** Created the Linux kernel in 1991; still final integrator of [torvalds/linux](https://github.com/torvalds/linux). Fellow at the [Linux Foundation](https://www.linuxfoundation.org/). Governance: hierarchical — subsystem maintainers aggregate patches; Linus merges the final pull requests.

**Public posture.** Primary channel is the [Linux kernel mailing list (LKML)](https://lore.kernel.org/lkml/). He does not run a blog or actively post on social media about kernel work. Canonical documents: the [coding-style.rst](https://github.com/torvalds/linux/blob/master/Documentation/process/coding-style.rst) and [submitting-patches.rst](https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst).

**Philosophy.** (1) *Never break userspace* — this is the kernel's first rule and Linus enforces it personally. (2) *Coding style matters because maintainability matters* — "coding style is very personal, and I won't force my views on anybody, but this is what goes for anything that I have to be able to maintain" ([coding-style.rst](https://github.com/torvalds/linux/blob/master/Documentation/process/coding-style.rst)). (3) *Interleaved inline replies only* — top-posting is the wrong style on LKML ([mailing-list etiquette](https://subspace.kernel.org/etiquette.html)). (4) *AI-generated code is acceptable if the submitter takes full responsibility* — the kernel's [2024 policy](https://www.webpronews.com/linus-torvalds-just-told-ai-coders-the-rules-how-linux-is-writing-the-playbook-for-machine-generated-kernel-code/) allows it but bans disclaimers.

**Contribution signals he welcomes.** Patches that route through the correct subsystem maintainer; bisectable series; well-written commit messages explaining *why*; regressions reports with `git bisect` already done.

**Contribution signals he rejects.** Anything breaking userspace ABI; patches bypassing the subsystem maintainer hierarchy; top-posted emails; patches generated by tools where the submitter can't defend every line. Linus has publicly flamed Google contributors for rc2-timing and process failures ([The Register 2024](https://www.theregister.com/2024/01/29/linux_6_8_rc2/)).

**Review tone.** Terse, gatekeeper, historically sharp. Post-2018, explicitly more moderated after Linus's [public apology and break](https://lkml.org/lkml/2018/9/16/167), though directness remains the norm.

**Response cadence.** Daily during merge windows. US Pacific / Portland timezone. Merge window is the two weeks after each release; do not submit disruptive changes during -rc stabilization.

**Fit notes.** Do not email Linus directly for a first patch — go through the subsystem `MAINTAINERS` file. Write your commit message for a reviewer ten years from now. Use `git format-patch` and `git send-email`, not GitHub PRs. Expect the signal density to be extreme; don't take it personally, take it literally.

---

## Daniel Stenberg curl

**Identity.** Founded curl in 1998; still lead developer. Works full-time on curl, sponsored via [wolfSSL](https://www.wolfssl.com/) ([GitHub Blog maintainer spotlight](https://github.blog/open-source/maintainers/maintainer-spotlight-daniel-stenberg/)). curl runs on ~10 billion devices.

**Public posture.** Blog at [daniel.haxx.se](https://daniel.haxx.se/); Mastodon [@bagder@mastodon.social](https://mastodon.social/@bagder); GitHub [@bagder](https://github.com/bagder). Canonical text: the free book [Uncurled](https://un.curl.dev/) — everything he has learned about running OSS. Representative talk: ["Uncurled — what I've learned about Open Source"](https://www.youtube.com/watch?v=jVT37EmND8I).

**Philosophy.** (1) *Maintainable code is kind to your future self* — clear writing, comments explaining *why*, test cases, documentation, and sensible hygiene matter most on long-running projects ([Uncurled](https://un.curl.dev/)). (2) *Say no when necessary, welcome newcomers always* — maintainers must gate scope but the community is how the project survives ([GitHub maintainer spotlight](https://github.blog/open-source/maintainers/maintainer-spotlight-daniel-stenberg/)). (3) *Contribution policies should be clear about AI* — curl's [AI contribution policy](https://github.com/curl/curl/blob/master/docs/AI.md) requires disclosure of AI usage in security reports and holds the submitter accountable for accuracy. (4) *Bug bounties failed when the AI-slop ratio exceeded ~29-to-1* — Stenberg paused the program publicly ([The New Stack 2025](https://thenewstack.io/curls-daniel-stenberg-ai-is-ddosing-open-source-and-fixing-its-bugs/)).

**Contribution signals he welcomes.** Bug reports that include `curl -V` output, a reproduction command, and tested hypothesis; PRs with test coverage in the curl test suite; documentation improvements; contributions to [`everything curl`](https://everything.curl.dev/).

**Contribution signals he rejects.** Fabricated LLM-generated "security vulnerabilities"; reports without reproductions; scope expansion that doesn't match curl's stated role as a data-transfer tool; CoC violations — Daniel enforces curl's [Code of Conduct](https://github.com/curl/curl/blob/master/docs/CODE_OF_CONDUCT.md) publicly.

**Review tone.** Discursive, mentor, firm on scope. Daniel will explain rejections at length rather than close silently.

**Response cadence.** First response on well-formed issues typically within 24 hours, often same-day. Sweden timezone (CET). He works on curl full-time and posts daily commit activity.

**Fit notes.** Read [Uncurled](https://un.curl.dev/) chapter "Bug reports" before filing. Disclose AI usage up front if any. Include a reproducible test case. Propose the patch as a pull request against master; do not wait to be invited. Do not argue scope — curl transfers data, and that framing ends most "why won't you add X" threads.

---

## Pattern Meta-Analysis

**1. Solo BDFLs value scope discipline more than any other signal.** Sindre, Anthony, Evan, and Rich will all close "feature creep" PRs fast. Before proposing *any* feature, restate the project's stated scope in one sentence and ask whether your proposal fits. If it doesn't, either write a separate module (Sindre's pattern) or open an RFC/discussion (Evan's pattern) rather than a PR.

**2. Foundation-governed maintainers route through process, not personality.** For Matz and Linus, the *mechanism* of contribution is itself a filter: the Ruby bug tracker + dev meeting, or the kernel subsystem `MAINTAINERS` tree. Bypassing process to reach the BDFL directly is a rejection signal. For solo BDFLs, direct engagement on the repo is normal and expected.

**3. Every maintainer over 5 years old has an essay you must read first.** Fabien's [Stability over Features](https://fabien.potencier.org/about-symfony-stability-over-features.html), Rich's [Write Less Code](https://svelte.dev/blog/write-less-code), Anthony's [Mental Health in OSS](https://antfu.me/posts/mental-health-oss), Daniel's [Uncurled](https://un.curl.dev/), Dan Abramov's [React Team Principles](https://overreacted.io/what-are-the-react-team-principles/), Matz's [Philosophy of Ruby](https://www.artima.com/articles/the-philosophy-of-ruby). These are not background reading — they are the rubric your contribution will be evaluated against.

**4. Backward compatibility posture is the single highest-variance axis.** Fabien and Linus treat BC breaks as near-criminal; Matz treats them as requiring strong justification; Sindre has publicly walked *away* from CJS compatibility; Evan ships major versions with migration paths. Before proposing any change, classify the project's BC posture and phrase your PR accordingly.

**5. Terse reviewers reward terse PRs; discursive reviewers reward reasoning.** Linus, Evan, Fabien, and Sindre respond best to small patches with one-line justifications. Rich, Anthony, Daniel, and Dan respond best to PR descriptions that explain motivation, trade-offs, and rejected alternatives. Match the prose density of the person you're shipping to.

**6. AI-assisted contributions are now an explicit policy axis.** Linus ([kernel AI policy](https://www.webpronews.com/linus-torvalds-just-told-ai-coders-the-rules-how-linux-is-writing-the-playbook-for-machine-generated-kernel-code/)) and Daniel ([curl AI policy](https://github.com/curl/curl/blob/master/docs/AI.md)) now publicly require disclosure and full submitter accountability. Assume every major project will adopt similar rules; disclose, and own every line.

**7. Sustainability framing wins over urgency framing, everywhere.** Sindre, Anthony, and Daniel have written publicly about burnout and the cost of entitlement. Across the whole sample, contributions framed as "this will save maintainer time over the next N releases" land better than "this is urgent for my use case." The maintainer's time horizon is always longer than yours.
