# Thamani Dawa Internal App Redesign Guide

## Purpose

This is the working UI/UX standard for redesigning Thamani Dawa's authenticated pharmacy, laboratory, and organization screens.

Use it when improving:

- tables and list pages;
- search, filters, and pagination;
- forms and multi-step workflows;
- dashboards and summary cards;
- record detail pages;
- empty, loading, success, warning, and error states;
- desktop, tablet, and mobile behavior.

The goal is a calm clinical interface that is minimal without feeling empty. It should help staff understand the current state, identify the next action, and complete work quickly.

This guide applies to the internal app. Public marketing and authentication pages may use a more editorial presentation.

## Source of truth

Before redesigning a screen, inspect:

1. `assets/css/app.css` for the active design tokens and Tailwind theme.
2. `lib/thamani_dawa_web/components/core_components.ex` for reusable components.
3. `lib/thamani_dawa_web/components/layouts.ex` for the internal shell.
4. A nearby screen that already implements the same workflow well.
5. Relevant LiveView tests so existing behavior and selectors remain intact.

If an older design document conflicts with the implemented tokens, `assets/css/app.css` wins.

## Design outcome

Every redesigned screen should answer these questions within a few seconds:

1. Where am I?
2. What record, patient, site, or workflow am I working on?
3. What is its current state?
4. What needs my attention?
5. What is the primary action?
6. What happened after I acted?

If the interface cannot answer these clearly, adding decoration will not fix it.

## Core principles

### 1. Make the workflow obvious

Organize the page around the user's task, not the database schema. Present information in the order it is needed.

```text
Context → Current state → Required work → Action → Confirmation
```

### 2. Minimal does not mean flat

Use restraint, but keep a visible hierarchy:

- 600 weight for page titles, section headings, identities, and important values;
- 500 weight for controls, navigation, labels, and table headers;
- 400 weight for body copy, supporting values, and descriptions;
- size, spacing, and color before adding more borders or bold text.

### 3. One clear primary action

Each page or panel should have one visually dominant action. Secondary actions should be outlined or text-based. Destructive actions must never compete visually with the normal workflow.

### 4. Prioritize scanning

Operational staff scan more than they read. Keep labels short, align repeated data, group related values, and reserve color for status or action.

### 5. Show state and next action together

Do not make users infer what to do from a status alone.

Good:

```text
Awaiting verification
[ Scan product barcode ] [ Verify product ]
```

Weak:

```text
Pending
```

### 6. Progressive disclosure

Show the information needed for the current decision. Place advanced filters, audit data, uncommon fields, and secondary actions behind clear disclosure controls.

### 7. Design every state

A screen is incomplete until it handles:

- initial loading;
- populated content;
- no results;
- first-use empty state;
- validation errors;
- server or network errors;
- disabled actions;
- submission in progress;
- partial completion;
- successful completion.

## Visual foundation

### Color

Use the existing Thamani tokens rather than introducing close substitutes.

| Role | Token or class | Use |
| --- | --- | --- |
| Page canvas | `--thamani-canvas` / `bg-thamani-canvas` | Internal app background |
| Primary surface | `--thamani-snow` / `bg-thamani-snow` | Cards, tables, forms |
| Primary brand | `--thamani-forest` / `text-thamani-forest` | Headings, primary actions, active states |
| Soft brand tint | `--thamani-lime` / `bg-thamani-lime` | Active navigation, small highlights |
| Border | `--thamani-stone` / `border-thamani-stone` | Dividers and component outlines |
| Secondary text | `--thamani-pewter` / `text-thamani-pewter` | Supporting information |
| Tertiary text | `--thamani-subtle` / `text-thamani-subtle` | Labels and low-emphasis metadata |
| Error | `--thamani-error` | Destructive actions and failures |

Semantic colors:

- emerald: complete, verified, available, healthy;
- amber: pending, attention required, approaching a limit;
- sky: in progress or informational;
- rose: failed, unavailable, dangerous, destructive;
- slate: neutral, inactive, or unknown.

Always pair semantic color with text or an icon. Never communicate state with color alone.

### Typography

Use Inter for the internal app.

| Role | Recommended style |
| --- | --- |
| Page title | `text-xl sm:text-2xl font-semibold tracking-tight` |
| Section title | `text-base or text-lg font-semibold` |
| Card title | `text-sm or text-base font-semibold` |
| Body | `text-sm font-normal leading-6` |
| Control | `text-sm font-medium` |
| Label | `text-xs font-medium` |
| Eyebrow | `text-xs font-medium uppercase tracking-wide` |
| Key value | `text-lg or text-xl font-semibold tabular-nums` |

Avoid:

- 700+ weights;
- uppercase sentences;
- tiny body copy;
- excessive letter spacing;
- using brand purple for every piece of text.

### Spacing

Use a 4px base rhythm with common increments of 8, 12, 16, 20, 24, and 32px.

- page sections: `gap-5` or `gap-6`;
- related controls: `gap-2` or `gap-3`;
- standard card padding: `p-4 sm:p-5`;
- important overview padding: `p-5 sm:p-6`;
- compact table cells: `px-4 py-3`;
- comfortable table cells: `px-5 py-3.5`.

Do not use empty space to compensate for weak hierarchy. A dense workflow can still feel calm when alignment and grouping are consistent.

### Shape and elevation

| Element | Radius |
| --- | --- |
| Inputs | 8px |
| Compact controls | 8–10px |
| Panels and tables | 12px |
| Primary cards | 16px |
| Badges and buttons | Full pill where already established |

Use subtle borders as the primary separation method. Use `shadow-sm` only on important top-level surfaces. Avoid stacking multiple shadows or placing every small group in its own card.

## Standard page anatomy

Most internal pages should follow this order:

```text
+--------------------------------------------------------------+
| Page title, useful subtitle                    Primary action |
|--------------------------------------------------------------|
| Search                                Filters   Secondary tool |
+--------------------------------------------------------------+

+--------------------------------------------------------------+
| Optional attention summary, metrics, or workflow status       |
+--------------------------------------------------------------+

+--------------------------------------------------------------+
| Main content: table, form, cards, or record detail             |
+--------------------------------------------------------------+
```

Use the shared `<.header>` component for standard list pages. Keep search and filters inside its `:toolbar` slot so the title and controls read as one unit.

Do not:

- place a page title in a floating card and filters in another unrelated card;
- repeat the same title in the shell, card, modal, and table;
- add summary cards when they do not support a decision;
- hide the primary action below the fold.

## Tables and list pages

### When to use a table

Use a table when users need to compare several records across the same fields.

Use cards instead when:

- each record has substantially different content;
- the next action is more important than comparison;
- the content is primarily visual;
- the screen is mobile-first and each item needs multiple actions.

Do not turn every desktop table into cards. Tables are usually the best interface for pharmacy stock, prescriptions, orders, laboratory results, sites, and team members.

### Recommended table structure

```text
+-----------------------------------------------------------------------+
| Products                                      [Search........] [Filter] |
+-----------------------------------------------------------------------+
| Product              Category       Stock       Status        Actions   |
|-----------------------------------------------------------------------|
| Metformin 500 mg     Antidiabetic      169       In stock       •••     |
| Amlodipine 10 mg     Cardiovascular     12       Low stock      •••     |
| Amoxicillin 500 mg   Antibiotic          0       Out of stock   •••     |
+-----------------------------------------------------------------------+
| 1–25 of 148                                      [Previous] [Next]      |
+-----------------------------------------------------------------------+
```

### Table rules

#### Columns

- Put the record's identity in the first column.
- Put status near the data that determines it.
- Put actions last.
- Show only fields needed for comparison or action.
- Move secondary metadata into a subdued second line within the primary cell.
- Avoid more than seven visible columns at common laptop widths.
- Use explicit units in headers or values: `KES`, `mg`, `units`, `days`.

#### Alignment

- text: left aligned;
- numbers: right aligned when comparison matters;
- short statuses: left or center aligned consistently;
- actions: right aligned;
- use `tabular-nums` for currency, quantities, dates, and counts.

#### Header

- use a soft canvas background;
- use 12–13px medium labels;
- keep labels on one line when practical;
- show a sort icon only for sortable columns;
- make the entire sortable header control clickable;
- expose sort direction with `aria-sort`.

#### Rows

- target 44–52px row height;
- use one quiet divider between rows;
- use a subtle hover background only when the row is interactive;
- use `cursor-pointer` only when clicking the row performs an action;
- provide a visible keyboard focus treatment;
- do not rely on double-click;
- avoid zebra stripes unless rows cannot be tracked reliably without them.

#### Primary cell

Use a two-line identity pattern:

```text
Metformin 500 mg          ← medium or semibold
GTIN 12345678901231       ← smaller, muted, monospaced if useful
```

#### Status

Use the shared `<.status_badge>` component. Keep status labels short and domain-specific:

- Pending
- In progress
- Completed
- Low stock
- Out of stock
- Awaiting review

Do not show a green badge for every normal value. Too much success color becomes visual noise.

#### Actions

- Make the common row action available by clicking the row or a clearly named button.
- Put uncommon actions in an overflow menu.
- Keep destructive actions separated and colored only inside the menu or confirmation dialog.
- Give icon-only controls an `aria-label` and tooltip.
- Do not display three or more equally prominent buttons in every row.

### Search and filters

Search should:

- describe what can be searched in its placeholder;
- use `phx-debounce` for LiveView queries;
- retain its value when filters change;
- include a clear control when populated;
- update the result count.

Filters should:

- show the number of active filters;
- use domain language;
- apply consistently;
- provide a single `Clear all` action;
- remain available after a no-results response;
- be encoded in the URL when users may bookmark or share the view.

Always distinguish:

```text
No records exist yet
```

from:

```text
No records match “metformin” and 2 active filters
```

The first needs a creation action. The second needs search/filter recovery.

### Responsive table behavior

Use these strategies in order:

1. Preserve the table and remove low-priority columns.
2. Keep the identity, key value, status, and primary action visible.
3. Allow horizontal scrolling inside the table container.
4. Add a visual cue when more columns are off-screen.
5. Use a purpose-built mobile card only when the row cannot remain understandable as a table.

Never allow the entire page to scroll horizontally.

For mobile cards, preserve the same information order:

```text
[Status]  Record identity
          Supporting metadata

Key label                       Key value
Secondary label           Secondary value

[Primary action]                         [•••]
```

### Table states

#### Loading

- retain the table's approximate height;
- show 4–6 skeleton rows;
- avoid replacing the whole page with a spinner;
- disable conflicting controls while a request is active.

#### Empty

Place the state inside the table container. Include:

- a relevant outline icon;
- a precise title;
- one sentence explaining the state;
- a primary action only when one is useful.

#### Error

Keep the header and controls usable. Show what failed and provide a retry action. Do not erase the last successfully loaded data unless displaying it would be unsafe.

#### Pagination

- show the current range and total;
- use Previous and Next at minimum;
- preserve search, filter, and sort state;
- return focus appropriately after navigation;
- do not use infinite scroll for compliance or audit-oriented data.

## Forms

### Form structure

Group fields by the decisions users make, not merely by schema:

```text
1. Patient
2. Medication
3. Dosage and instructions
4. Payment
5. Review and submit
```

Use one column by default. Use two columns only for naturally paired short fields, such as first/last dates or quantity/unit.

### Form rules

- Use `to_form/2` in the LiveView and `<.form for={@form}>` in HEEx.
- Use the shared `<.input>` component.
- Give every form and important control a stable DOM ID.
- Keep labels visible; placeholders are examples, not labels.
- Mark optional fields as optional instead of marking every required field.
- Place helper text before an error and close to its field.
- Validate after meaningful interaction, not before the user begins.
- Preserve entered values after validation or server errors.
- Put the primary submit action at the end of the form.
- Use `phx-disable-with` and prevent duplicate submission.

### Form actions

Desktop:

```text
[Cancel]                                      [Save prescription]
```

Mobile:

```text
[Save prescription — full width]
[Cancel — text/secondary]
```

For long forms, consider a sticky action footer only when it does not hide fields or errors.

### Dangerous actions

Deletion, cancellation, reversal, and stock corrections require:

- explicit naming of the affected record;
- a concise explanation of the effect;
- confirmation;
- a danger-styled confirmation action;
- a safe cancel action with initial focus when appropriate.

## Detail pages

Record detail pages should be workflow summaries, not database dumps.

Recommended structure:

1. Identity, state, essential metadata, and back navigation.
2. Compact summary values.
3. Alerts or clinical notes.
4. The record's primary workflow.
5. Secondary information and audit history.

Use a definition list for stable label/value metadata. Use cards for discrete tasks or stateful items.

For repeated workflow items, every card should show:

- identity;
- current state;
- key quantities or dates;
- instructions or context;
- the next action;
- a completed state after action.

Do not leave an empty action area after completion. Replace it with a compact confirmation state.

## Dashboards

Dashboards are for triage, not decoration.

Include a metric only if it supports a decision:

- pending orders;
- low-stock items;
- incomplete laboratory results;
- prescriptions awaiting verification;
- stock expiring soon.

Each metric should state:

- what is counted;
- the time or site context;
- whether it needs attention;
- where clicking it goes.

Avoid:

- vanity metrics;
- charts with fewer than three meaningful points;
- multiple colors without semantic meaning;
- large cards containing only a number and no action.

## Buttons and actions

### Hierarchy

| Level | Style | Use |
| --- | --- | --- |
| Primary | Filled brand button | One main action per page or task panel |
| Secondary | Outlined/ghost button | Back, cancel, alternate action |
| Tertiary | Text or icon button | Low-frequency utility |
| Danger | Red text or fill after confirmation | Destructive action |

Button labels should use a verb and object:

- `Add product`
- `Dispense medication`
- `Verify product`
- `Save result`
- `Invite staff member`

Avoid vague labels:

- `Submit`
- `Proceed`
- `Okay`
- `Yes`

## Feedback and system status

### Success

Confirm the completed action and show the resulting state. Prefer inline confirmation when the action affects one card; use flash messages for page-level outcomes.

### Warning

Warnings should state:

1. what requires attention;
2. why it matters;
3. what the user can do.

### Error

Use plain language. Preserve context and entered data. Put field errors beside fields and page-level failures near the affected workflow.

### Loading

Use:

- `phx-disable-with` for submissions;
- subtle opacity changes on affected controls;
- skeletons for initial content;
- small inline spinners for local actions.

Do not block the entire page for an action affecting one row.

## Responsive behavior

Design from the smallest useful width, then enhance.

### Mobile

- one content column;
- 16px page padding;
- full-width primary actions;
- stacked label/value content when space is limited;
- no hidden critical status or action;
- touch targets at least 44px;
- no horizontal page overflow.

### Tablet

- retain one column for complex forms;
- allow two-column summaries;
- keep filters in a drawer if the toolbar becomes crowded.

### Desktop

- use available width for comparison and workflow context;
- avoid stretching paragraphs or forms across the full 1600px content area;
- cap reading/form widths while allowing tables to expand.

Test at approximately 375px, 768px, 1024px, and 1440px.

## Accessibility

Every redesign must include:

- semantic headings in order;
- labels for every input;
- keyboard access to all controls;
- visible focus styles;
- `aria-current="page"` for active navigation where supported;
- `aria-sort` for sortable table headers;
- `aria-label` for icon-only actions;
- live announcements for important async outcomes;
- text plus color for status;
- sufficient contrast;
- reduced-motion support;
- meaningful empty and error messages.

Do not make a non-interactive `<div>` behave like a button. Use a real button or link.

## Motion and interaction

Motion should explain change, not decorate it.

- hover/focus transitions: 120–180ms;
- panel or drawer transitions: 180–240ms;
- use opacity, color, and small transforms;
- avoid bouncing, large scaling, and long entrance animations;
- respect `prefers-reduced-motion`.

Rows, cards, and buttons should not all lift on hover. Reserve elevation changes for genuinely interactive top-level cards.

## Content and language

Use concise, specific, sentence-case copy.

Good:

- `No prescriptions match these filters.`
- `3 items are low in stock.`
- `Scan the product barcode to verify it.`

Avoid:

- `No data available.`
- `An error occurred.`
- `Kindly proceed to perform verification.`

Use the terminology staff already use. Do not rename clinical or operational concepts merely to sound friendlier.

## Phoenix LiveView implementation rules

- Begin every authenticated template with the appropriate `<Layouts.*_shell>`.
- Use existing shared components before creating new markup.
- Use `<.icon>` for icons.
- Use `<.input>` and forms created with `to_form/2`.
- Add stable, unique DOM IDs to pages, forms, tables, rows, buttons, and important values.
- Use LiveView streams for changing collections.
- A stream container needs a DOM ID and `phx-update="stream"`.
- Track counts and empty state separately because streams are not enumerable.
- Use `push_patch` or `<.link patch={...}>` for URL-backed filters.
- Do not use inline JavaScript. Use colocated or external LiveView hooks.
- Preserve existing events, parameters, routes, permissions, and data scope during visual refactors.
- Do not add dependencies for ordinary UI behavior.
- Do not use `@apply`.
- Do not introduce a second component library or new color system.

## Reusable list-page pattern

```heex
<Layouts.pharmacy_shell
  flash={@flash}
  current_scope={@current_scope}
  current_path={~p"/pharmacy/prescriptions"}
>
  <div id="prescriptions-page" class="space-y-5">
    <.header icon="hero-document-text">
      Prescriptions
      <:subtitle>Review, dispense, and verify patient prescriptions.</:subtitle>
      <:actions>
        <.button variant="primary" phx-click="new">
          <.icon name="hero-plus" class="size-4" /> Add prescription
        </.button>
      </:actions>
      <:toolbar>
        <form id="prescription-search" phx-change="search" class="min-w-64 flex-1">
          <.search_input
            name="search"
            value={@search}
            placeholder="Search patient or prescription..."
          />
        </form>
        <.filter_drawer id="prescription-filters" apply_event="apply_filters">
          <%!-- Filter fields --%>
        </.filter_drawer>
      </:toolbar>
    </.header>

    <.table id="prescriptions" rows={@streams.prescriptions}>
      <:col :let={prescription} label="Patient">
        <%!-- Identity and supporting metadata --%>
      </:col>
      <:col :let={prescription} label="Status">
        <.status_badge status={prescription.status} />
      </:col>
      <:action :let={prescription}>
        <%!-- One common action or overflow menu --%>
      </:action>
      <:empty_state>
        <.blank_state title="No prescriptions found">
          Try changing your search or filters.
        </.blank_state>
      </:empty_state>
    </.table>
  </div>
</Layouts.pharmacy_shell>
```

Adapt the content to the workflow. Do not copy markup without understanding the screen.

## Redesign process

### 1. Audit

Document:

- the user's main job on the page;
- primary and secondary actions;
- information needed to make a decision;
- current pain points;
- all UI states;
- desktop and mobile constraints;
- existing tests and DOM hooks.

### 2. Simplify

Remove:

- duplicated headings;
- redundant metadata;
- unnecessary cards;
- repeated borders;
- actions that can move to an overflow menu;
- instructions that the design can make self-evident.

Do not remove useful context merely to make the page look sparse.

### 3. Establish hierarchy

Order the page by:

1. context;
2. attention;
3. work;
4. supporting information.

### 4. Implement

- reuse tokens and components;
- preserve behavior;
- add stable IDs;
- implement responsive and interactive states;
- keep component APIs domain-neutral when reuse is likely.

### 5. Verify

- test with realistic long names and values;
- test zero, one, and many records;
- test loading, empty, error, and completed states;
- test keyboard navigation;
- inspect mobile and desktop widths;
- run formatter, focused tests, asset build, and `mix precommit`.

## Definition of done

A redesign is complete when:

- the page's purpose is obvious;
- the primary action is easy to find;
- status and next action are connected;
- important records can be scanned and compared;
- mobile has no lost functionality or page-level overflow;
- empty, loading, error, disabled, and success states are intentional;
- keyboard and focus behavior work;
- all controls have clear labels;
- existing permissions and data scoping remain unchanged;
- shared components are used consistently;
- relevant tests use stable DOM IDs and assert outcomes;
- assets compile and `mix precommit` passes.

## Common anti-patterns

Do not:

- put every section in a separate floating card;
- make all text medium or semibold;
- use brand purple for all values;
- use color without a label;
- show every possible field in a table;
- put several outlined buttons in every row;
- hide essential actions in hover-only UI;
- use placeholders as labels;
- show a spinner where a skeleton or local loading state is clearer;
- use a generic empty state for filtered results;
- convert desktop tables into unreadable horizontal layouts on mobile;
- add large empty areas for the sake of minimalism;
- redesign visual appearance while ignoring validation, loading, and failure states.

The standard is not “clean-looking.” The standard is calm, clear, safe, and fast to use.
