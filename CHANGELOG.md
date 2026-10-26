# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Each entry is headed by the date the dependency update run was performed.

## 2026-10-26

### Security

- Updated ruby 4.0.7 → 4.0.9 — fixes CVE-2026-93577, CVE-2026-97229, CVE-2026-110264 (regexp compiler overflows)
- Updated crass 1.0.7 → 1.0.8 and sanitize 7.0.0 → 7.0.1 — fixes GHSA-pq4g-8rxf-4g29 (CSS sanitizer bypass)
- Updated pg 1.6.3 → 1.7.0 — memory-safety fixes and SQL injection guard in `set_client_encoding`
- Updated puppeteer 24.43.1 → 25.16.0 — drops extract-zip, basic-ftp and ip-address (5 advisories, extract-zip unpatchable); zod → 4.6.7
- Updated transitive fast-uri 3.1.8 → 3.1.9 and source-map-js 1.2.1 → 1.2.2 via `resolutions`

### Changed

- Updated rails 8.1.3.1 → 8.1.4, govuk-frontend 6.5.1 → 6.6.0, govuk_design_system_formbuilder 6.5.0 → 6.6.0
- Updated sentry-ruby/rails/sidekiq 6.7.0 → 7.1.0, redis 5.4.1 → 6.0.0, json 2.21.2 → 3.1.0, prometheus-client 4.2.5 → 5.0.0
- Updated brakeman 8.0.6 → 8.1.0, cuprite 0.18 → 0.19, listen 3.10.0 → 3.10.1, lograge 0.15.0 → 0.15.1, rspec_junit_formatter 0.6.0 → 0.8.0, selenium-webdriver 4.49.0 → 4.51.0, webmock 3.26.4 → 3.34.0

### Known issues

- cucumber 12.0.0 not applied: cucumber-rails 4.1.0 requires cucumber < 12
- Deferred (released within 7 days): aws-sdk-s3, mutant-rspec, parser, pry, rubocop, vernier, sass, webpack
- simplecov held at 0.22.0 (SonarQube cannot parse the 1.x report format)

## 2026-08-14

### Security

- Updated rails 8.1.3 → 8.1.3.1 — fixes CVE-2026-66066 (possible arbitrary file read and remote code execution in Active Storage variant processing)
- Updated devise 4.9.4 → 5.0.4 — fixes CVE-2026-32700 (confirmable "change email" race condition) and CVE-2026-40295 (open redirect via unvalidated `request.referrer` in Timeoutable session timeout handler)
- Updated loofah 2.25.1 → 2.25.2 — fixes GHSA-5qhf-9phg-95m2, GHSA-8whx-365g-h9vv (`javascript:` URI detection bypasses) and GHSA-9wjq-cp2p-hrgf (SVG `href` local-reference restriction bypass)
- Updated rails-html-sanitizer 1.7.0 → 1.7.1 — fixes GHSA-cj75-f6xr-r4g7 (possible XSS with certain sanitizer configurations)
- Updated crass 1.0.6 → 1.0.7 — fixes GHSA-6jxj-px6v-747w, GHSA-6wmf-3r64-vcwv, GHSA-8vfg-2r28-hvhj, GHSA-wwpr-jff3-395c (CSS parsing denial-of-service issues)
- Updated json 2.20.0 → 2.21.2 — fixes CVE-2026-71847 (freed input buffer dereference in `JSON::ResumableParser`)
- Updated puppeteer 24.35.0 → 24.43.1 and its transitive dependencies ws → 8.21.3 (GHSA-58qx-3vcg-4xpx, GHSA-96hv-2xvq-fx4p), basic-ftp → 5.3.1 (GHSA-6v7q-wjvx-w8wg, GHSA-chqc-8p9q-pq6q, GHSA-rp42-5vxx-qpwr, GHSA-rpmf-866q-6p89), ip-address → 10.5.0 (GHSA-v2v4-37r5-5v8g, GHSA-mwp4-54f8-5fhr), js-yaml → 4.3.1 (GHSA-h67p-54hq-rp68, GHSA-52cp-r559-cp3m, GHSA-5p4m-2wfm-xmqj)
- Updated sass transitive dependencies picomatch → 4.0.5 (GHSA-3v7f-55p6-f55p, GHSA-c2c7-rcm5-vvqj) and immutable → 5.1.9 (GHSA-v56q-mh7h-f735, GHSA-xvcm-6775-5m9r)
- Updated webpack transitive dependency fast-uri → 3.1.5 (GHSA-v2hh-gcrm-f6hx, GHSA-7p8r-x3mc-p8w7, GHSA-q3j6-qgpj-74h6, GHSA-v39h-62p7-jpjc, GHSA-4c8g-83qw-93j6)

### Changed

- Updated puma 7.2.1 → 8.0.2
- Updated cucumber 9.2.1 → 11.1.1 (with cucumber-core, cucumber-gherkin, cucumber-html-formatter, cucumber-messages, cucumber-rails)
- Updated sanitize 6.1.3 → 7.0.0
- Updated govuk_design_system_formbuilder 5.13.0 → 6.4.0 — markup smoke-test fixtures updated: v6 intentionally no longer gives supplemental content an `id` or links it to the fieldset via `aria-describedby`
- Updated omniauth-auth0 3.1.1 → 3.2.0 (jwt moved 3.2.0 → 2.10.3 to satisfy its dependency)
- Updated site_prism 5.2 → 6.0.1
- Updated govuk-frontend 6.0.0 → 6.4.0
- Updated jquery 3.7.1 → 4.0.0
- Updated webpack-cli 6.0.1 → 7.2.2
- Updated sass 1.97.2 → 1.102.0
- Updated webpack 5.104.1 → 5.109.2
- Updated anonymous_loader 0.1.2 → 0.1.3, auth-sanitizer 0.2.2 → 0.2.3, aws-partitions 1.1262.0 → 1.1280.0, aws-sdk-core 3.252.0 → 3.254.1, aws-sdk-kms 1.129.0 → 1.130.0, aws-sdk-s3 1.226.0 → 1.229.0, brakeman 8.0.5 → 8.0.6, concurrent-ruby 1.3.7 → 1.3.8, csv 3.3.5 → 3.3.6, erb 6.0.4 → 6.0.7, execjs 2.10.1 → 2.10.2, globalid 1.3.0 → 1.4.0, io-console 0.8.2 → 0.9.2, language_server-protocol 3.17.0.5 → 3.17.0.6, lograge 0.14.0 → 0.15.0, mail 2.9.0 → 2.9.1, net-imap 0.6.4.1 → 0.6.6, oauth2 2.0.24 → 2.0.25, parser 3.3.11.1 → 3.3.12.0, rack 3.2.6 → 3.2.7, redis-client 0.30.0 → 0.30.1, redis-store 1.11.0 → 1.12.0, reline 0.6.3 → 0.7.0, rubocop 1.88.0 → 1.89.0, rubocop-ast 1.49.1 → 1.50.0, rubyzip 3.4.0 → 3.4.1, selenium-webdriver 4.45.0 → 4.47.0, sentry-rails/sentry-ruby/sentry-sidekiq 6.6.2 → 6.7.0, site_prism-all_there 3.0.9 → 3.0.10, snaky_hash 2.0.6 → 2.0.7, sorbet-runtime 0.6.13310 → 0.6.13426, version_gem 1.1.13 → 1.1.15, zeitwerk 2.8.2 → 2.8.3

### Known issues

- extract-zip 2.0.1 (transitive, via puppeteer > @puppeteer/browsers) — GHSA-jmr9-qjv8-65gv has no patched release in any version; monitor for an upstream fix
- redis gem held at 5.4.1 — 6.0.0 was released 2026-07-31 (major bump, sidekiq/redis-store compatibility risk); revisit in a dedicated PR
- puppeteer held on 24.x — 25.7.0 major available; revisit in a dedicated PR
- simplecov deliberately held at 0.22.0 — simplecov 1.x emits a JSON report format SonarQube cannot parse (`sonar.ruby.coverage.reportPaths` points at `coverage/coverage.json`)
