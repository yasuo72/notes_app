import '../../features/notes/domain/entities/note_category.dart';
import '../../features/notes/domain/entities/note_entity.dart';

/// Predefined realistic, lengthy, and professional sample notes.
class SampleNotesData {
  SampleNotesData._();

  static List<NoteEntity> getInitialSampleNotes() {
    final now = DateTime.now();
    return [
      // 1. Work - Pinned (Enterprise Architecture)
      NoteEntity(
        id: 'sample-work-01',
        title: 'Enterprise Microservices & Event-Driven Architecture 🏢',
        content: '''Executive Architectural Overview:
We are transitioning our core monolith to an asynchronous, event-driven microservices architecture to handle peak surges up to 100,000 transactions per second.

Core Architectural Tenets:
1. Domain-Driven Design (DDD):
   • Explicit Bounded Contexts around Order Processing, Inventory Management, and Customer Billing.
   • Strict database-per-service pattern to prevent cross-service database coupling.
   
2. Asynchronous Event Streaming:
   • Apache Kafka as the central immutable distributed event log.
   • Transactional Outbox Pattern with Debezium CDC (Change Data Capture) to guarantee at-least-once delivery without distributed 2PC locking.
   
3. Fault Tolerance & Circuit Breaking:
   • Resilience4j integration with dynamic failure threshold (50% failure rate triggers half-open fallback).
   • Exponential backoff with jitter on transient network timeouts.
   
4. Observability & Distributed Tracing:
   • OpenTelemetry instrumentation propagating W3C TraceContext across gRPC and HTTP boundaries.
   • Centralized Jaeger dashboard and Prometheus SLO monitoring (99.9th percentile latency < 120ms).''',
        category: NoteCategory.work,
        colorValue: 0,
        isPinned: true,
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now.subtract(const Duration(minutes: 25)),
      ),

      // 2. Ideas - Pinned (AI Startup Proposal)
      NoteEntity(
        id: 'sample-ideas-02',
        title: 'Autonomous AI Code Review & Security Vulnerability Engine 🤖',
        content: '''Product Vision & Architecture Concept:
An intelligent CI/CD integrated agent that doesn't just check lint rules, but reasons about code logic, concurrency bugs, and zero-day dependency exploits.

Key Technical Differentiators:
• Hybrid Static AST Analysis + LLM Reasoning:
  Rather than dumping entire files into the model context, we parse the Abstract Syntax Tree (AST) using tree-sitter. We extract diff-impacted control flow graphs and send only high-entropy slices to the model.

• Threat Modeling & Taint Analysis:
  Traces unvalidated user inputs from HTTP controllers directly into SQL/NoSQL queries, shell execution points, and serialization boundaries.

• Actionable PR Refactoring:
  Instead of generic warnings, the bot submits a targeted git patch with a verified unit test that reproduces the defect and confirms the fix.

Target Integrations:
- GitHub Actions, GitLab CI, and Bitbucket Pipelines.
- IDE Extension with real-time semantic hints for VS Code and Android Studio.''',
        category: NoteCategory.ideas,
        colorValue: 2,
        isPinned: true,
        createdAt: now.subtract(const Duration(hours: 8)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),

      // 3. Task - Pinned (Security Audit)
      NoteEntity(
        id: 'sample-task-03',
        title: 'Q4 Production Readiness & Security Audit Checklist 🛡️',
        content: '''Mandatory Release Governance Checklist:

[Phase A: Cryptography & Secrets Management]
[ ] Rotate all production AWS KMS master keys and database credentials.
[ ] Ensure zero hardcoded API keys or staging URLs in git history via automated Gitleaks scan.
[ ] Enforce TLS 1.3 only across ingress load balancers with HSTS enabled (max-age 31536000).

[Phase B: Infrastructure & Network Hardening]
[ ] Review Kubernetes NetworkPolicies: deny all ingress by default across internal pods.
[ ] Run automated CIS benchmark compliance check on worker nodes.
[ ] Verify multi-region database failover drill (RPO < 1 min, RTO < 5 mins).

[Phase C: Application & Mobile Security]
[ ] Run ProGuard / R8 code obfuscation verification on production release bundles.
[ ] Validate certificate pinning hash sets for all financial payment gateway endpoints.
[ ] Confirm biometrics and keystore encryption tokens expire on logout or jailbreak detection.''',
        category: NoteCategory.task,
        colorValue: 1,
        isPinned: true,
        createdAt: now.subtract(const Duration(hours: 12)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),

      // 4. Personal (Philosophy & Reflection)
      NoteEntity(
        id: 'sample-personal-04',
        title: 'Stoic Principles, Time Management & Deep Focus Rules 📖',
        content: '''Reflections on Seneca’s "On the Shortness of Life":
"It is not that we have a short time to live, but that we waste a lot of it. Life is long enough, and a sufficiently generous estimate has been given to us for the highest achievements if it were all well invested."

Daily Execution Principles:
1. The 90/90/1 Rule:
   For the next 90 days, dedicate the first 90 minutes of your workday entirely to your single most impactful technical objective. No email, no messaging, no social feeds.

2. Negative Visualization (Premeditatio Malorum):
   Anticipate technical obstacles, production outages, and unexpected delays every morning. When problems occur, greet them with calm clarity rather than emotional resistance.

3. Evening Audit Questions:
   • Where was my attention divided today?
   • Did I react with discipline or impulsiveness?
   • What meaningful craft or knowledge did I cultivate?''',
        category: NoteCategory.personal,
        colorValue: 3,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // 5. Work (Flutter Performance Engineering)
      NoteEntity(
        id: 'sample-work-05',
        title: 'Flutter 3.35 High-Performance Rendering & Memory Profiling ⚡',
        content: '''Engineering Guidelines for Achieving Consistent 120 FPS on Mobile:

1. RepaintBoundary Isolation:
   Wrap heavy animated widgets or scrolling items with RepaintBoundary. This prevents changes in a small UI element from invalidating the entire layer tree.

2. Const Constructor Discipline:
   Always use const constructors wherever possible. This ensures Flutter reuses existing Element tree instances instead of allocating fresh widgets during rebuild cycles.

3. List & Grid Memory Recycling:
   Use MasonryGridView.count with appropriate cacheExtent. Never construct unbounded children columns inside SingleChildScrollView for large datasets.

4. Stream & Controller Lifecycle:
   Enforce automatic disposal of TextEditingControllers, ScrollControllers, and RxWorker listeners in the onClose() lifecycle of GetxController to eliminate silent background memory leaks.''',
        category: NoteCategory.work,
        colorValue: 0,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // 6. Ideas (Decentralized Mesh Networking)
      NoteEntity(
        id: 'sample-ideas-06',
        title: 'Decentralized Mesh Networking for Disaster Relief Zones 🌐',
        content: '''Autonomous Emergency Communication Architecture:
When terrestrial cellular towers fail during floods, earthquakes, or storms, affected populations need resilient, zero-infrastructure messaging.

Hardware & Protocol Stack:
• Physical Layer: Semtech SX1262 LoRa transceivers operating on ISM 868/915 MHz bands with range up to 15km line-of-sight.
• Routing Protocol: Ad-hoc On-Demand Distance Vector (AODV) with hop count limiting (max 7 hops) to prevent packet storm loops.
• Client Connectivity: ESP32 dual-core microcontrollers exposing Bluetooth Low Energy (BLE) peripheral GATT services to civilian smartphones.

App Capabilities:
- End-to-end encrypted packet broadcast for emergency medical requests.
- Offline GPS waypoint telemetry mapping nearest water and shelter drops.
- Automatic solar harvesting power budget calculations (1.2W continuous).''',
        category: NoteCategory.ideas,
        colorValue: 2,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),

      // 7. Personal (Nutrition & Meal Planning)
      NoteEntity(
        id: 'sample-personal-07',
        title: 'The Complete High-Protein Mediterranean Meal Strategy 🥗',
        content: '''Nutritional Foundation & Weekly Strategy:
Target Metrics: 2,300 kcal • 185g Protein • 75g Healthy Fats • 210g Complex Carbs.

Core Weekly Grocery Staples:
• Protein: Wild-caught salmon, organic chicken breast, Greek yogurt (0% fat), cage-free whole eggs, cottage cheese.
• Complex Carbs: Steel-cut oats, organic tri-color quinoa, sweet potatoes, sourdough bread, black lentils.
• Healthy Lipids: Cold-pressed extra virgin olive oil, Haas avocados, raw almonds, walnuts, chia seeds.
• Micronutrients & Greens: Baby spinach, broccoli sprouts, blueberries, organic kale, pomegranate seeds.

Daily Meal Timing:
- 08:00 AM: Scrambled eggs + spinach + sliced avocado on toasted sourdough.
- 01:00 PM: Grilled chicken quinoa bowl with roasted bell peppers and tahini dressing.
- 05:00 PM: Whey isolate smoothie with frozen berries, rolled oats, and almond butter.
- 08:30 PM: Pan-seared wild salmon over steamed asparagus and mashed sweet potato.''',
        category: NoteCategory.personal,
        colorValue: 3,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),

      // 8. Task (Engineering Onboarding Roadmap)
      NoteEntity(
        id: 'sample-task-08',
        title: 'Senior Software Engineer 30-60-90 Day Onboarding Plan 🎓',
        content: '''Structured Roadmap for New Senior Engineering Hires:

First 30 Days (Assimilation & Foundation):
[x] Setup local development sandbox, Docker compose stacks, and VPN credentials.
[x] Pair program with core team leads across critical service repositories.
[x] Ship first production hotfix and participate in bi-weekly sprint planning.

Days 31 to 60 (Autonomy & Ownership):
[ ] Take primary ownership of the offline sync engine refactor.
[ ] Lead architectural design review (ADR) for database indexing improvements.
[ ] Shadow on-call primary engineer during weekly incident response rotation.

Days 61 to 90 (Leadership & Innovation):
[ ] Establish CI/CD automated linting and performance benchmark gates.
[ ] Mentor associate developers through structured weekly 1:1 code walkthroughs.
[ ] Propose next quarter technical roadmap for latency reduction.''',
        category: NoteCategory.task,
        colorValue: 1,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      // 9. Ideas (Smart Hydroponic Greenhouse)
      NoteEntity(
        id: 'sample-ideas-09',
        title: 'Smart IoT Hydroponic Greenhouse Automation Platform 🌱',
        content: '''Closed-Loop Precision Agriculture System:
Designed for urban indoor vertical farms requiring zero soil and minimal water consumption.

Hardware & Sensor Nodes:
• Analog pH probe with galvanic isolation circuit.
• Total Dissolved Solids (TDS / Electrical Conductivity) probe for nutrient saturation.
• Non-contact ultrasonic water level sensor in the central reservoir.
• Peristaltic dosing pumps driven by 12V stepper motors for micro-dosing nutrient solutions.

Cloud & Mobile Dashboard:
- Real-time WebSocket connection streaming water temperature, ambient lux, and humidity.
- Adaptive PID controller tuning pump runtimes based on plant growth phase.
- Machine vision leaf analysis detecting nitrogen deficiency using onboard ESP32-CAM.''',
        category: NoteCategory.ideas,
        colorValue: 2,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),

      // 10. Personal (High-Altitude Expedition Prep)
      NoteEntity(
        id: 'sample-personal-10',
        title: '10-Day Alpine Trek & Mountaineering Expedition Logistics 🏔️',
        content: '''Preparation Guide for Himachal Great Himalayan National Park Trek:

Elevation Profile: Base Camp 2,400m ➔ High Pass 4,850m.

Acclimatization Schedule:
• Day 1-2: Easy hike to 2,900m, sleep at 2,600m ("Climb high, sleep low").
• Day 3: Active rest day; hydration focus (minimum 4.5 liters daily with electrolyte replenishment).
• Day 4-6: Push to Advance Base Camp (3,800m); monitor resting heart rate and blood oxygen saturation (SpO2 > 85%).

Essential Gear Checklist:
- 4-season geodesic expedition tent with snow skirt.
- 800-fill down sleeping bag rated for -15°C comfort limit.
- Gore-Tex Pro shell jacket & waterproof pants.
- Garmin inReach Mini 2 satellite communicator for emergency SOS beacons.
- High-calorie freeze-dried ration packs (4,000 kcal/day allowance).''',
        category: NoteCategory.personal,
        colorValue: 3,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),

      // 11. Work - Pinned (Zero-Trust Security)
      NoteEntity(
        id: 'sample-work-11',
        title: 'Zero-Trust Cloud Architecture & Zero-Day Defense Matrix 🔐',
        content: '''Comprehensive Multi-Cloud Security Posture:
We are deploying a zero-trust network access (ZTNA) model across AWS, GCP, and on-premises colocation facilities to neutralize lateral movement attack vectors.

1. Identity-Centric Access & Workload Attestation:
   • Mutual TLS (mTLS) with SPIFFE/SPIRE cryptographically verifying container identity at runtime.
   • Ephemeral short-lived JWT tokens signed by HashiCorp Vault with maximum 15-minute TTL.
   • Strict elimination of static API keys, service account JSON files, and long-lived IAM credentials.

2. Software Supply Chain Hardening (SLSA Level 4):
   • Cryptographic container signing using Sigstore / Cosign in GitHub Actions pipeline.
   • Automated Software Bill of Materials (SBOM) generation via Syft during Docker build stages.
   • Daily Grype & Trivy vulnerability scans rejecting any image containing CVSS >= 7.0 CVEs.

3. Micro-Segmentation & Boundary Enforcement:
   • Cilium eBPF network policies operating at the kernel level for sub-millisecond packet filtering.
   • Deny-all default egress policy; explicitly whitelisted external REST & gRPC endpoint domains.
   • Real-time automated quarantine trigger powered by AWS GuardDuty & Falco runtime audit logs.''',
        category: NoteCategory.work,
        colorValue: 0,
        isPinned: true,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),

      // 12. Ideas (Edge AI Vision)
      NoteEntity(
        id: 'sample-ideas-12',
        title: 'Edge AI Vision for Industrial High-Speed Assembly Inspection 👁️',
        content: '''Autonomous Computer Vision Inspection Pipeline:
Automating surface defect detection and solder joint verification on high-speed SMT printed circuit board manufacturing lines.

Hardware Architecture & Sensor Selection:
• Optical Sensor: Basler ace 2 GigE Vision camera capturing 12MP monochrome frames at 160 FPS.
• Lighting Setup: Multi-angle coaxial dome LED strobe illuminator preventing specular glare on solder fillets.
• Compute Node: NVIDIA Jetson Orin Industrial (275 TOPS INT8) enclosed in an IP67 passively-cooled chassis.

Deep Learning Model Topology:
• Backbone: RepVGG-B2 quantized to FP16 and INT8 using TensorRT optimization engine.
• Head: Dual-head architecture outputting bounding box coordinates and 8-class defect classification (bridging, tombstoning, insufficient wetting, voiding, misaligned chips).
• Latency Benchmark: 11.4ms total inference time per board, enabling 100% inline inspection at conveyor speed of 1.2 m/s.

Data Flywheel & Active Learning:
- Uncertain predictions (entropy score > 0.45) automatically streamed via MQTT to a central MinIO S3 bucket.
- Semi-supervised pseudo-labeling retraining weekly model iterations without human intervention.''',
        category: NoteCategory.ideas,
        colorValue: 2,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 9)),
        updatedAt: now.subtract(const Duration(days: 9)),
      ),

      // 13. Task - Pinned (SOC-2 Compliance)
      NoteEntity(
        id: 'sample-task-13',
        title: 'Global SOC-2 Type II Compliance & External Penetration Testing 📋',
        content: '''Sprint Action Items for Annual Compliance Attestation & Red-Teaming:

[Module 1: Access Governance & IAM Verification]
[x] Perform quarterly user access reviews (UAR) across AWS, GCP, GitHub, Jira, and Slack.
[x] Enforce mandatory hardware security keys (FIDO2 / YubiKey) for all infrastructure administrators.
[ ] Automate employee offboarding webhook: revoke all SSO sessions within 60 seconds of HR trigger.

[Module 2: Penetration Testing & Vulnerability Remediation]
[ ] External black-box penetration testing execution with Bishop Fox (Target window: Oct 12 - Oct 26).
[ ] Remediate high-severity findings: patch OAuth 2.0 redirect URI regex validation in Auth Service.
[ ] Validate rate-limiting protection against distributed credential-stuffing on /v1/auth/login.

[Module 3: Business Continuity & Disaster Recovery Drill]
[ ] Perform live unannounced database failover simulation from us-east-1 to us-west-2.
[ ] Verify Recovery Time Objective (RTO <= 8 minutes) and Recovery Point Objective (RPO <= 30 seconds).
[ ] Archive signed audit evidence artifacts to immutable AWS S3 Glacier Vault with Compliance Lock.''',
        category: NoteCategory.task,
        colorValue: 1,
        isPinned: true,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // 14. Personal (Neuroscience & Focus)
      NoteEntity(
        id: 'sample-personal-14',
        title: 'Neuroscience of Deep Work, Circadian Biology & Peak Focus 🧠',
        content: '''Protocol for Maximizing Cognitive Output & Endocrine Harmony:
Synthesized from Dr. Andrew Huberman and Cal Newport's research on circadian entrainment and sustained attention.

1. Morning Photobiological Protocol:
   • View 10,000 to 30,000 lux natural sunlight within 30 minutes of waking for 15-20 minutes.
   • Suppresses melatonin secretion and triggers a healthy cortisol pulse, advancing alertness and setting the internal circadian timer for evening sleepiness 14-16 hours later.
   • Delay caffeine intake by 90-120 minutes post-waking to allow adenosine clearance and prevent afternoon crashes.

2. Bimodal Deep Work Windows:
   • Window 1 (08:30 AM - 11:30 AM): Peak analytical and architectural problem-solving. Phone in another room, airplane mode active, single browser tab open.
   • Window 2 (02:30 PM - 04:30 PM): Code refactoring, documentation synthesis, and technical roadmap planning.

3. Evening Sleep Architecture & Recovery:
   • Cease blue-light exposure 90 minutes before bed; dim room lighting to warm amber spectrum.
   • Lower ambient room temperature to 18.5°C (65°F) to facilitate the physiological 1°C core body temperature drop necessary for NREM slow-wave sleep.''',
        category: NoteCategory.personal,
        colorValue: 3,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 11)),
        updatedAt: now.subtract(const Duration(days: 11)),
      ),

      // 15. Work (Distributed Financial Ledger)
      NoteEntity(
        id: 'sample-work-15',
        title: 'Distributed Double-Entry Financial Ledger & Settlement Engine 💳',
        content: '''Fault-Tolerant Core Banking Architecture:
Designed for high-concurrency payment processing, wallet balances, and merchant payouts with zero financial discrepancies.

Foundational Accounting Invariants:
• Pure Double-Entry Bookkeeping: Every financial event consists of at least one debit and one credit where sum(debits) - sum(credits) == 0.
• Immutable Ledger Table: Balance updates are strictly append-only; row mutations or deletions are disallowed via database triggers and user permission revocations.

Concurrency Control & Race Condition Mitigation:
• Idempotency Keys: Client requests require a unique UUIDv7 idempotency token cached in Redis Cluster with 24-hour expiration.
• Optimistic Locking via Sequence Versioning: Accounts record a monotonic revision counter. Write conflicts rollback and retry with exponential jitter.
• Hot-Wallet Sharding: High-volume merchant accounts are partitioned into 10 virtual sub-accounts to prevent row-lock contention on Postgres SELECT FOR UPDATE.

Reconciliation & Auditability:
- Daily asynchronous reconciliation jobs comparing running balances against cumulative ledger transaction sums.
- Cryptographic Merkle tree hashing of hourly ledger snapshots published to an append-only audit log.''',
        category: NoteCategory.work,
        colorValue: 0,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 12)),
        updatedAt: now.subtract(const Duration(days: 12)),
      ),

      // 16. Ideas (Neuromorphic SNNs)
      NoteEntity(
        id: 'sample-ideas-16',
        title: 'Neuromorphic Spiking Neural Networks for Ultra-Low Power IoT ⚡',
        content: '''Event-Driven Bio-Inspired Edge Intelligence:
Transitioning from power-hungry Von Neumann tensor accelerators to event-driven neuromorphic silicon (Intel Loihi 2 & BrainChip Akida).

Architectural Principles:
• Temporal Spike Encoding: Information is represented as discrete spikes in time rather than continuous 32-bit floating point numbers.
• Event-Driven Execution: Neurons consume static zero-power until an incoming synaptic spike arrives, dropping standby consumption below 50 microwatts.
• On-Chip Plasticity: Real-time Spike-Timing-Dependent Plasticity (STDP) allowing continuous local learning without backpropagation.

Applications & Prototype Benchmarks:
1. Acoustic Keyword Spotting & Gunshot Detection:
   • Continual listening at 180 microwatts on a single CR2032 coin cell for 3+ years.
2. Vibration Anomaly Telemetry in Wind Turbines:
   • Sub-millisecond detection of bearing micro-fractures before catastrophic mechanical failure.''',
        category: NoteCategory.ideas,
        colorValue: 2,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 13)),
        updatedAt: now.subtract(const Duration(days: 13)),
      ),

      // 17. Task (Mobile Release Protocol)
      NoteEntity(
        id: 'sample-task-17',
        title: 'Flutter Mobile App Launch, Telemetry & App Store Optimization 🚀',
        content: '''Comprehensive Production Release & Go-To-Market Protocol:

[Phase 1: Build Verification & Bundle Optimization]
[x] Run tree-shaking and ProGuard / R8 code shrinking verification on Android AAB bundle.
[x] Compress SVG assets and generate WebP raster images, reducing final APK download size to < 18MB.
[ ] Verify iOS release archive with bitcode disabled and universal xcframework linking.

[Phase 2: Observability & Crash Reporting]
[ ] Configure Sentry / Firebase Crashlytics with symbolicated de-obfuscation mapping files uploaded.
[ ] Establish real-time Slack alerting channel for fatal ANR (Application Not Responding) rates > 0.05%.
[ ] Instrument custom analytics funnels: User Onboarding -> Note Created -> Tag Assigned -> Search Executed.

[Phase 3: App Store & Play Store Compliance]
[ ] Complete Google Play Data Safety declaration and iOS Privacy Nutrition labels.
[ ] Prepare localized screenshot carousels for 6.7" iPhone, 6.1" iPhone, and 10.5" iPad screens.
[ ] Initiate staged rollout: 5% on Day 1, 15% on Day 2, 50% on Day 4, and 100% on Day 7.''',
        category: NoteCategory.task,
        colorValue: 1,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 14)),
      ),

      // 18. Personal (Endurance & Marathon)
      NoteEntity(
        id: 'sample-personal-18',
        title: 'Endurance Physiology, VO2 Max Protocols & Lactate Clearance 🏃',
        content: '''Evidence-Based 16-Week Aerobic Conditioning Blueprint:
Designed for half-marathon and marathon performance targeting sub-3:15 finish time.

1. Polarized 80/20 Training Distribution:
   • 80% Volume in Zone 2 Aerobic Base (68-75% Maximum Heart Rate):
     Fosters mitochondrial biogenesis, enhances capillary density around slow-twitch muscle fibers, and trains enzymatic systems to oxidize lipids instead of glycogen.
   • 20% Volume in Zone 4/5 (Lactate Threshold & VO2 Max Intervals):
     4x4-minute intervals at 92-95% HR max with 3-minute active recoveries to push cardiac output and stroke volume.

2. Intra-Run Fueling & Glycogen Replenishment:
   • Consume 60-80 grams of dual-source carbohydrates (maltodextrin:fructose in 1:0.8 ratio) per hour on runs exceeding 75 minutes.
   • Ingest 500-750mg sodium per liter of hydration fluid to maintain blood plasma volume and prevent hyponatremia.

3. Injury Prevention & Soft-Tissue Resilience:
   • Bi-weekly eccentric heel drops on a step for Achilles tendon stiffness and plantar fascia integrity.
   • Heavy barbell Bulgarian split squats and Romanian deadlifts to correct unilateral pelvic imbalances.''',
        category: NoteCategory.personal,
        colorValue: 3,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),

      // 19. Work (Kubernetes GitOps)
      NoteEntity(
        id: 'sample-work-19',
        title: 'Multi-Cluster Kubernetes GitOps & Automated Canary Rollouts ☸️',
        content: '''Production Delivery Automation Architecture:
Zero-downtime continuous deployment engine across heterogeneous EKS and GKE clusters using ArgoCD and Flagger.

1. Declarative GitOps Pipeline:
   • Single Git repository as the authoritative source of truth for all Kubernetes manifests.
   • ArgoCD reconciliation controller continuously polling git commits; out-of-sync drifts auto-corrected within 60 seconds.
   • Kustomize overlays managing per-environment configuration variances (staging vs production).

2. Automated Canary Progression via Istio Mesh:
   • Flagger orchestrating progressive traffic routing: 5% -> 15% -> 30% -> 60% -> 100% over a 15-minute window.
   • Prometheus metric validation queries running at each canary interval:
     - HTTP request success rate must remain > 99.9%.
     - p99 service latency must remain < 85ms.
   • Automatic rollback triggered within 30 seconds if error thresholds are violated, alerting on-call via PagerDuty.

3. Secrets & Configuration Encryption:
   • Bitnami Sealed Secrets encrypting sensitive credentials directly inside public git repositories with asymmetric public keys.''',
        category: NoteCategory.work,
        colorValue: 0,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 16)),
        updatedAt: now.subtract(const Duration(days: 16)),
      ),

      // 20. Task (Lakehouse Data Pipeline)
      NoteEntity(
        id: 'sample-task-20',
        title: 'Data Pipeline Migration & Real-Time Lakehouse Infrastructure 🛠️',
        content: '''Migration Roadmap from Batch Data Warehouse to Apache Iceberg & Spark Streaming:

[Phase 1: Ingestion & Schema Evolution]
[x] Deploy Debezium CDC connectors across all production transactional databases.
[x] Configure Apache Kafka topics with snappy compression and 7-day retention.
[ ] Define Protobuf schemas with Confluent Schema Registry enforcement.

[Phase 2: Apache Iceberg Storage Layer]
[ ] Provision AWS S3 bucket with S3 Intelligent-Tiering and server-side KMS encryption.
[ ] Implement Apache Spark Structured Streaming with 60-second micro-batches.
[ ] Configure automated Iceberg compaction jobs (bin-packing small files into 512MB Parquet).
[ ] Schedule orphan file cleanup and snapshot expiration retaining 14 days of historical time-travel.

[Phase 3: Analytics & BI Governance]
[ ] Connect Trino / Starburst distributed SQL query engine for sub-second dashboards.
[ ] Implement column-level data masking for PII fields using Apache Ranger.
[ ] Validate query parity and data integrity between legacy Redshift and Iceberg lakehouse.''',
        category: NoteCategory.task,
        colorValue: 1,
        isPinned: false,
        createdAt: now.subtract(const Duration(days: 17)),
        updatedAt: now.subtract(const Duration(days: 17)),
      ),
    ];
  }
}
