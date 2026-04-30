# FRONTEND_ARCHITECTURE-template.md

**Derivado de**: BMAD V4 `bmad-core/templates/front-end-architecture-tmpl.yaml` v2.0.
**Produzido por**: Arthur (arquiteto-de-software) via capability CA, lado frontend.
**Complementa**: `SOFTWARE_ARCHITECTURE.md` (backend/sistema) — documento-irmão obrigatório.
**Artefato final**: `artifacts/FRONTEND_ARCHITECTURE.md`.

---

**Cabeçalho esperado do artefato final (quando Arthur criar)**:

```markdown
# {{project_name}} — Frontend Architecture Document

**Projeto**: {{project_name}}
**Alias**: {{project_alias}}
**Cliente**: {{client_name}}
**Versão do Documento**: 1.0
**Status**: Rascunho | Em Elicitação | Aprovado
**Autor**: Arthur (Arquiteto de Software)
**Data**: {{iso_date}}
**Documento-irmão**: `artifacts/SOFTWARE_ARCHITECTURE.md` (backend/sistema)

---
```

**Frontmatter YAML esperado** (Arthur atualiza durante CA):

```yaml
---
template_version: "1.0"
scope: frontend
stepsCompleted: []  # vai sendo preenchido: [template-framework, tech-stack, project-structure, components, state, api-integration, routing, styling, testing, environment, dev-standards]
currentStatus: draft  # draft | in_elicitation | approved
lastUpdated: null
references:
  prd: "artifacts/PRD.md"
  anexo_a: "artifacts/ANEXO_A_ProcessDetails.md"
  software_architecture: "artifacts/SOFTWARE_ARCHITECTURE.md"
  ubiquitous_language: "UBIQUITOUS_LANGUAGE.yaml"
  terminology_map: "claude/TERMINOLOGY_MAP.yaml"
---
```

---

## 0. Pré-condição: projeto tem UI?

**Instruction for agent**: antes de iniciar elicitação, Arthur verifica no PRD se o projeto tem componente UI significativo.

- **Se NÃO** (ex.: projeto é exclusivamente API/backend/worker/batch): Arthur cria este arquivo contendo **apenas** o cabeçalho, esta seção §0 com nota "N/A — projeto sem UI" + registro no changelog + referência explícita ao `SOFTWARE_ARCHITECTURE.md`, e encerra. As seções §1–§10 não são preenchidas; ficam marcadas como N/A.
- **Se SIM**: Arthur prossegue com todas as seções abaixo.

**Template content:**

```
- **Escopo UI**: [Sim / Não]
- **Justificativa (se N/A)**: [ex.: "projeto é apenas API REST sem frontend próprio — clientes externos consomem OpenAPI spec"]
- **Decidido em**: {{iso_date}}
```

---

## 1. Template and Framework Selection

<!-- elicit: true (subsection Starter Template) -->
<!-- source: V4 front-end-architecture-tmpl §template-framework-selection -->

**Instruction for agent**: Revisar PRD, UX-UI Specification (se existir), e `SOFTWARE_ARCHITECTURE.md`. Foco: extrair detalhes de implementação frontend necessários para tools de IA e Dev agents. Pedir ao usuário qualquer documento ausente.

Antes de prosseguir com design frontend, checar se o projeto usa frontend starter template ou codebase existente:

1. Revisar PRD, SOFTWARE_ARCHITECTURE.md e brief por menções a:
   - Frontend starter templates (ex.: Create React App, Next.js, Vite, Vue CLI, Nuxt, Angular CLI, SvelteKit).
   - UI kit ou component library starters (ex.: shadcn/ui, Material UI templates, Chakra UI).
   - Projetos frontend existentes servindo de fundação.
   - Admin dashboard templates ou starters especializados (ex.: Refine, Tremor).
   - Design system implementations.

2. Se starter ou projeto existente for mencionado:
   - Pedir ao usuário acesso via link/upload/repositório.
   - Analisar starter para entender: dependências pré-instaladas + versões; folder structure; componentes built-in; styling approach (CSS Modules / styled-components / Tailwind); state management setup; routing; testing setup; build scripts.
   - Usar análise para alinhar a arquitetura frontend com os patterns do starter.

3. Se sem starter mas projeto novo com UI, confirmar framework e linguagem:
   - React: Create React App, Next.js, Vite + React.
   - Vue: Vue CLI, Nuxt.js, Vite + Vue.
   - Angular: Angular CLI.
   - Svelte: SvelteKit.
   - Ou sugerir UI templates populares se aplicável.

4. Se usuário confirmar from-scratch sem starter:
   - Notar esforço de setup manual (bundling, tooling, configuração).
   - Prosseguir com arquitetura frontend do zero.

**Documentar a decisão de starter template e constraints impostas antes de prosseguir.**

**Elicitation requirement**:
- Subseção "Starter Template or Existing Project" exige decisão explícita do usuário.
- Subseção "Change Log" é apenas tabela — não requer elicitação.

---

### 1.1 Starter Template or Existing Project

<!-- elicit: true -->

**Template content (preencher):**

```
Decisão: [Starter template | Projeto existente adaptado | Greenfield sem starter | N/A]
- Nome/versão/link: ...
- Razão: ...
- Limitações/adaptações: ...
- Constraints impostos ao projeto: ...
```

---

### 1.2 Change Log

<!-- source: V4 front-end-architecture-tmpl §changelog (tipo table) -->

**Template content:**

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| {{iso_date}} | 1.0 | Rascunho inicial do Frontend Architecture Document | Arthur |

---

## 2. Frontend Tech Stack

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §frontend-tech-stack -->

**Instruction for agent** (V4 §frontend-tech-stack): extrair da Technology Stack Table da arquitetura principal (`SOFTWARE_ARCHITECTURE.md §3`). **Esta seção DEVE permanecer sincronizada com o documento de arquitetura principal** para decisões cross-stack (linguagem, package manager, build target, targets de runtime).

Para cada categoria, apresentar 2-3 opções viáveis com prós/contras, recomendar com justificativa, e obter aprovação explícita do usuário. **Versões pinadas** (nunca "latest") — princípio não-negociável de Arthur.

**Referência cross-documento**: categorias que já foram decididas em `SOFTWARE_ARCHITECTURE.md §3` (ex.: linguagem TypeScript, package manager pnpm) devem ser **referenciadas**, não redecididas.

**Elicitation requirement**: máxima — esta seção bloqueia as seguintes (Project Structure, Component Standards, State Management dependem da escolha de framework UI).

---

### 2.1 Technology Stack Table

**Template content (V4 §frontend-tech-stack.tech-stack-table, type: table, colunas literais do V4):**

| Category | Technology | Version | Purpose | Rationale |
|----------|------------|---------|---------|-----------|
| Framework | {{framework}} | {{version}} | {{purpose}} | {{why_chosen}} |
| UI Library | {{ui_library}} | {{version}} | {{purpose}} | {{why_chosen}} |
| State Management | {{state_management}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Routing | {{routing_library}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Build Tool | {{build_tool}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Styling | {{styling_solution}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Testing | {{test_framework}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Component Library | {{component_lib}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Form Handling | {{form_library}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Animation | {{animation_lib}} | {{version}} | {{purpose}} | {{why_chosen}} |
| Dev Tools | {{dev_tools}} | {{version}} | {{purpose}} | {{why_chosen}} |

**Exemplos (preencher com decisão real):**

```
| Framework | Next.js | 14.2.3 | SSR/SSG + routing + API routes | Melhor balanço SEO/DX para projeto com marketing público + dashboard |
| UI Library | React | 18.3.1 | Base | Ecossistema maduro, escolha default |
| State Management | Zustand | 4.5.2 | Global state client-side | Leve vs Redux, sem boilerplate, TS-first |
| Routing | Next.js App Router | (bundled) | File-based routing | Convenção Next.js, RSC-aware |
| Build Tool | Turbopack | (bundled Next) | Dev + build | Default Next 14, sem config extra |
| Styling | Tailwind CSS | 3.4.3 | Utility-first styling | Velocidade de iteração, consistência via design tokens |
| Testing | Vitest + React Testing Library | 1.5.0 + 14.3.1 | Unit + component | Compatível com Vite, mais rápido que Jest |
| Component Library | shadcn/ui | (copy-paste) | Base primitivos Radix | Sem lock-in, control total |
| Form Handling | React Hook Form + Zod | 7.51.3 + 3.23.0 | Forms + validação | Perf, ergonomia, schema-first |
| Animation | Framer Motion | 11.2.6 | Micro-interactions | Declarativo, bem integrado React |
| Dev Tools | Storybook | 8.0.10 | Component catalog | Documenta components para BA/PM |
```

**Categorias adicionais opcionais** (Arthur expande se necessário):
- Internationalization (i18next, next-intl, react-intl)
- Accessibility libs (react-aria, @radix-ui/react-*)
- Icons (lucide-react, heroicons, phosphor-icons)
- Data fetching / cache (TanStack Query, SWR, Apollo Client se GraphQL)
- WebSocket / real-time (socket.io-client, Pusher)
- Error tracking (Sentry, Rollbar — cross-stack, coordenar com backend)

---

## 3. Project Structure

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §project-structure (type: code, language: plaintext) -->

**Instruction for agent** (V4 §project-structure): definir estrutura exata de diretórios para tools de IA baseada no framework escolhido. Ser específico sobre onde cada tipo de arquivo vai. Gerar estrutura que siga best practices e convenções do framework.

**Referência cross-documento**: o monorepo top-level (ex.: `packages/web/`) foi decidido em `SOFTWARE_ARCHITECTURE.md §8 Source Tree`. Esta seção detalha o **interior** do pacote frontend.

**Elicitation requirement**: Arthur propõe estrutura, pede aprovação por nível.

**Template content (adaptar ao framework escolhido):**

```
packages/web/                         # (ou src/ se polyrepo, ou apps/web/ se Turborepo)
├── public/                          # assets estáticos (favicon, manifest, robots.txt)
├── src/
│   ├── app/ ou pages/               # routing file-based (Next.js App Router / Nuxt pages / Angular modules)
│   │   ├── (marketing)/             # route groups
│   │   ├── (dashboard)/
│   │   ├── api/                     # API routes (se SSR framework)
│   │   ├── layout.tsx               # root layout
│   │   └── page.tsx                 # home
│   ├── components/
│   │   ├── ui/                      # primitivos (shadcn/ui, MUI, etc.)
│   │   ├── features/                # componentes por feature/domínio
│   │   │   └── <bounded-context>/   # espelha modulos do PRD §10
│   │   └── layouts/                 # headers, sidebars, shell
│   ├── hooks/                       # custom hooks
│   ├── stores/                      # state management (Zustand/Pinia/NgRx)
│   ├── services/                    # API clients (consome §6 REST API Spec do backend)
│   │   └── api/
│   ├── lib/                         # utilitários puros
│   ├── styles/                      # globals, theme vars
│   ├── types/                       # TS types compartilhados (cuidado: domain types podem vir de packages/shared/)
│   └── config/                      # env config, feature flags
├── tests/
│   ├── unit/                        # component unit tests
│   ├── e2e/                         # Playwright / Cypress
│   └── fixtures/
├── .storybook/                      # config Storybook (se adotado)
├── next.config.js                   # ou vite.config.ts / nuxt.config.ts / angular.json
├── tailwind.config.ts               # se Tailwind
├── tsconfig.json
└── package.json
```

Arthur adapta ao framework escolhido (Vue → `pages/`, `composables/`; Angular → `src/app/<feature>/{components,services,models}`; SvelteKit → `src/routes/`, `src/lib/`).

---

## 4. Component Standards

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §component-standards -->

**Instruction for agent** (V4 §component-standards): definir patterns exatos para criação de componentes baseado no framework escolhido.

**Elicitation requirement**: Arthur apresenta template, pede aprovação do usuário para ser fixado como padrão do projeto.

---

### 4.1 Component Template

**Instruction** (V4 §component-standards.component-template, type: code, language: typescript): gerar template mínimo mas completo, seguindo best practices do framework. Incluir TypeScript types, imports adequados e estrutura básica.

**Template content (exemplo React + shadcn/ui; adaptar ao framework):**

```typescript
// src/components/features/<bounded-context>/<ComponentName>.tsx

import { forwardRef, type ComponentPropsWithoutRef } from 'react'
import { cn } from '@/lib/utils'

export interface {{ComponentName}}Props extends ComponentPropsWithoutRef<'div'> {
  // props específicas
  variant?: 'default' | 'compact'
}

export const {{ComponentName}} = forwardRef<HTMLDivElement, {{ComponentName}}Props>(
  ({ className, variant = 'default', children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(
          'base-classes',
          variant === 'compact' && 'compact-classes',
          className
        )}
        {...props}
      >
        {children}
      </div>
    )
  }
)

{{ComponentName}}.displayName = '{{ComponentName}}'
```

**Exemplo Vue 3 Composition API (alternativa):**

```typescript
<script setup lang="ts">
interface Props {
  variant?: 'default' | 'compact'
}
const props = withDefaults(defineProps<Props>(), { variant: 'default' })
</script>

<template>
  <div :class="['base', props.variant === 'compact' && 'compact']">
    <slot />
  </div>
</template>
```

---

### 4.2 Naming Conventions

**Instruction** (V4 §component-standards.naming-conventions): convenções específicas do framework escolhido para components, files, services, state management, e demais elementos arquiteturais.

**Para IDs de domínio** (bc_id, aggregate_id, command_id, etc.): **LINKAR** para `claude/TERMINOLOGY_MAP.yaml` `naming_conventions:`. **Não duplicar** aqui.

**Template content (V4 type: table):**

| Element | Convention | Example |
|---------|-----------|---------|
| Component file | PascalCase.tsx | `EditalCard.tsx` |
| Hook file | camelCase prefixed `use` | `useEditalStatus.ts` |
| Service file | kebab-case `.service.ts` | `edital-api.service.ts` |
| Store file (Zustand) | kebab-case `-store.ts` | `auth-store.ts` |
| Type file | kebab-case `.types.ts` | `edital.types.ts` |
| Test file | match source + `.spec.tsx`/`.test.tsx` | `EditalCard.spec.tsx` |
| Storybook file | match source + `.stories.tsx` | `EditalCard.stories.tsx` |
| CSS Module | kebab-case `.module.css` | `edital-card.module.css` |
| Env var | `NEXT_PUBLIC_*` / `VITE_*` | `NEXT_PUBLIC_API_URL` |
| Domain IDs | ver TERMINOLOGY_MAP.yaml | — |

---

## 5. State Management

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §state-management -->

**Instruction for agent** (V4 §state-management): definir patterns de state management baseados no framework escolhido.

**Elicitation requirement**: Arthur apresenta estrutura de store + template; usuário confirma.

---

### 5.1 Store Structure

**Instruction** (V4 §state-management.store-structure, type: code, language: plaintext): gerar a estrutura de diretórios de state management apropriada para o framework e solução escolhidos.

**Template content (exemplo Zustand; adaptar):**

```
src/stores/
├── auth-store.ts                    # sessão, user, tokens
├── ui-store.ts                      # theme, sidebar state, modais globais
├── <bounded-context>-store.ts       # um store por bounded context (§10 PRD)
│   ├── editais-store.ts             # ex.: seleção atual, filtros, paginação
│   └── propostas-store.ts
├── middleware/
│   ├── persist.ts                   # localStorage/sessionStorage
│   ├── logger.ts                    # dev-only logging
│   └── devtools.ts                  # Redux DevTools bridge
└── index.ts                         # re-exports + hydration helpers
```

**Alternativas por framework:**

- **Redux Toolkit**: `src/features/<slice>/<slice>Slice.ts` + `src/app/store.ts`.
- **Pinia (Vue)**: `src/stores/<module>.ts` com `defineStore`.
- **NgRx (Angular)**: `src/app/state/<feature>/{actions,reducers,effects,selectors}.ts`.
- **React Context apenas** (projetos pequenos): `src/contexts/<Feature>Context.tsx`.

---

### 5.2 State Management Template

**Instruction** (V4 §state-management.state-template, type: code, language: typescript): template base com TypeScript types e operações comuns (set, update, clear).

**Template content (exemplo Zustand; adaptar):**

```typescript
// src/stores/editais-store.ts

import { create } from 'zustand'
import { devtools, persist } from 'zustand/middleware'

interface EditalFilter {
  status?: 'rascunho' | 'publicado' | 'aprovado'
  orgao?: string
}

interface EditaisState {
  selectedId: string | null
  filter: EditalFilter
  setSelectedId: (id: string | null) => void
  setFilter: (filter: Partial<EditalFilter>) => void
  clearFilter: () => void
  reset: () => void
}

const initialState = { selectedId: null, filter: {} }

export const useEditaisStore = create<EditaisState>()(
  devtools(
    persist(
      (set) => ({
        ...initialState,
        setSelectedId: (id) => set({ selectedId: id }),
        setFilter: (filter) => set((state) => ({ filter: { ...state.filter, ...filter } })),
        clearFilter: () => set({ filter: {} }),
        reset: () => set(initialState),
      }),
      { name: 'editais-store' }
    ),
    { name: 'editais' }
  )
)
```

---

## 6. API Integration

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §api-integration -->

**Instruction for agent** (V4 §api-integration): definir patterns de API service baseados no framework escolhido.

**Referência cross-documento**: esta seção consome a OpenAPI spec definida em `SOFTWARE_ARCHITECTURE.md §6 REST API Spec`. Endpoints, auth method e error codes DEVEM estar alinhados.

**Elicitation requirement**: Arthur apresenta service template + client config; usuário aprova.

---

### 6.1 Service Template

**Instruction** (V4 §api-integration.service-template, type: code, language: typescript): template de API service seguindo convenções do framework, com TypeScript types, error handling e async patterns adequados.

**Template content (exemplo com TanStack Query + Axios; adaptar):**

```typescript
// src/services/api/editais.service.ts

import { apiClient } from './client'
import type { Edital, CreateEditalCommand, UpdateEditalCommand } from '@/types/edital.types'

export const editaisService = {
  async list(params?: { status?: string; page?: number }) {
    const { data } = await apiClient.get<{ items: Edital[]; total: number }>('/editais', { params })
    return data
  },

  async getById(id: string) {
    const { data } = await apiClient.get<Edital>(`/editais/${id}`)
    return data
  },

  async create(command: CreateEditalCommand) {
    const { data } = await apiClient.post<Edital>('/editais', command)
    return data
  },

  async aprovar(id: string) {
    const { data } = await apiClient.post<Edital>(`/editais/${id}/aprovar`)
    return data
  },
}

// Integração com TanStack Query (opcional mas recomendado)
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'

export function useEditaisList(params?: { status?: string; page?: number }) {
  return useQuery({ queryKey: ['editais', params], queryFn: () => editaisService.list(params) })
}

export function useAprovarEdital() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: editaisService.aprovar,
    onSuccess: () => qc.invalidateQueries({ queryKey: ['editais'] }),
  })
}
```

---

### 6.2 API Client Configuration

**Instruction** (V4 §api-integration.api-client-config, type: code, language: typescript): configurar HTTP client com interceptors de auth, middleware e error handling.

**Template content (exemplo Axios; adaptar a fetch/ky/got):**

```typescript
// src/services/api/client.ts

import axios, { AxiosError } from 'axios'
import { useAuthStore } from '@/stores/auth-store'

export const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL ?? '/api',
  timeout: 15_000, // alinhado com SOFTWARE_ARCHITECTURE.md §10 Error Handling
  headers: { 'Content-Type': 'application/json' },
})

// Interceptor: anexa bearer token + X-Correlation-ID
apiClient.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token
  if (token) config.headers.Authorization = `Bearer ${token}`
  config.headers['X-Correlation-ID'] = crypto.randomUUID()
  return config
})

// Interceptor: error handling + refresh de token
apiClient.interceptors.response.use(
  (resp) => resp,
  async (error: AxiosError<{ code: string; message: string }>) => {
    if (error.response?.status === 401) {
      await useAuthStore.getState().refresh()
      // retry opcional
    }
    // normalizar erro para UI (toast global, error boundary, etc.)
    return Promise.reject(error)
  }
)
```

---

## 7. Routing

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §routing -->

**Instruction for agent** (V4 §routing): definir estrutura e patterns de routing baseados no framework escolhido.

**Elicitation requirement**: Arthur propõe route tree, protected routes, lazy loading, auth guards.

---

### 7.1 Route Configuration

**Instruction** (V4 §routing.route-configuration, type: code, language: typescript): configuração de routing apropriada para o framework, incluindo protected route patterns, lazy loading e auth guards/middleware.

**Template content (exemplo Next.js App Router; adaptar):**

```typescript
// src/app/layout.tsx (root)
import { AuthProvider } from '@/components/providers/auth-provider'
import { QueryProvider } from '@/components/providers/query-provider'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>
        <AuthProvider>
          <QueryProvider>{children}</QueryProvider>
        </AuthProvider>
      </body>
    </html>
  )
}

// src/app/(dashboard)/layout.tsx (protected group)
import { redirect } from 'next/navigation'
import { getServerSession } from '@/lib/auth'

export default async function DashboardLayout({ children }: { children: React.ReactNode }) {
  const session = await getServerSession()
  if (!session) redirect('/login')
  return <DashboardShell>{children}</DashboardShell>
}

// src/middleware.ts (Next.js middleware — edge)
import { NextResponse, type NextRequest } from 'next/server'

export function middleware(req: NextRequest) {
  const isAuthed = req.cookies.has('session')
  if (!isAuthed && req.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', req.url))
  }
}

export const config = { matcher: ['/dashboard/:path*'] }
```

**Alternativas por framework:**

- **React Router v6**: `createBrowserRouter` com loaders + `errorElement` + lazy routes.
- **Vue Router 4**: `navigation guards` (`beforeEach`) para auth + lazy-loaded components.
- **Angular Router**: `CanActivate` guards + lazy modules via `loadChildren`.

---

## 8. Styling Guidelines

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §styling-guidelines -->

**Instruction for agent** (V4 §styling-guidelines): definir abordagem de styling baseada no framework escolhido.

**Elicitation requirement**: Arthur propõe metodologia + theme base; usuário confirma.

---

### 8.1 Styling Approach

**Instruction** (V4 §styling-guidelines.styling-approach): descrever metodologia apropriada ao framework (CSS Modules, Styled Components, Tailwind, SCSS + BEM, etc.) e fornecer patterns básicos.

**Template content:**

```
- **Metodologia**: [Tailwind CSS | CSS Modules | Styled Components | Emotion | Vanilla Extract | SCSS + BEM]
- **Justificativa**: [texto]
- **Design Tokens**: [fonte: Figma tokens / CSS vars / tailwind config]
- **Responsive Breakpoints**: [mobile-first | desktop-first], breakpoints [sm:640, md:768, lg:1024, xl:1280]
- **Dark Mode**: [suportado | não suportado], estratégia [CSS vars + `prefers-color-scheme` | classe `.dark` toggle manual]
- **Accessibility Base**: [WCAG 2.1 AA como piso; componentes via Radix/react-aria/headlessui]
- **Iconografia**: [biblioteca escolhida, ex.: lucide-react; convenção de tamanhos]
- **Tipografia**: [font family, scale type (modular ratio), font loading (next/font | self-hosted)]
```

---

### 8.2 Global Theme Variables

**Instruction** (V4 §styling-guidelines.global-theme, type: code, language: css): sistema de CSS custom properties (CSS vars) funcional cross-frameworks. Incluir cores, spacing, typography, shadows e suporte dark mode.

**Template content (exemplo — Arthur adapta à paleta do cliente):**

```css
/* src/styles/theme.css */

:root {
  /* Colors — Light */
  --color-primary: 220 90% 56%;             /* hsl */
  --color-primary-foreground: 0 0% 100%;
  --color-secondary: 220 14% 96%;
  --color-accent: 262 83% 58%;
  --color-destructive: 0 84% 60%;
  --color-muted: 220 14% 96%;
  --color-background: 0 0% 100%;
  --color-foreground: 222 47% 11%;
  --color-border: 220 13% 91%;
  --color-ring: 220 90% 56%;

  /* Spacing — baseado em escala 4px */
  --spacing-xs: 0.25rem;                    /* 4px */
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;
  --spacing-2xl: 3rem;

  /* Typography */
  --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);

  /* Border radius */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-full: 9999px;

  /* Transitions */
  --transition-fast: 150ms ease-out;
  --transition-base: 200ms ease-out;
}

.dark {
  --color-background: 222 47% 11%;
  --color-foreground: 0 0% 100%;
  --color-border: 220 13% 20%;
  --color-muted: 220 14% 15%;
  /* sobrescreve conforme necessário */
}
```

---

## 9. Testing Requirements

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §testing-requirements -->

**Instruction for agent** (V4 §testing-requirements): definir requisitos mínimos de testing baseados no framework escolhido.

**Escopo desta seção**: testes **frontend** (component + integration UI + E2E UI + visual regression). Testes backend (unit + integration backend + e2e API-level) são escopo de `SOFTWARE_ARCHITECTURE.md §12 Test Strategy`.

**Elicitation requirement**: máxima — Arthur pede confirmação de cobertura mínima, frameworks, e-2e scope.

---

### 9.1 Component Test Template

**Instruction** (V4 §testing-requirements.component-test-template, type: code, language: typescript): template base de component test usando a testing library recomendada pelo framework. Incluir rendering tests, user interaction tests e mocking.

**Template content (exemplo Vitest + React Testing Library; adaptar):**

```typescript
// src/components/features/editais/EditalCard.spec.tsx

import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { EditalCard } from './EditalCard'

const mockEdital = {
  id: 'ed-001',
  titulo: 'Edital 01/2026',
  status: 'publicado' as const,
  orgao: 'Secretaria de Saúde',
}

describe('<EditalCard />', () => {
  it('renderiza título e status', () => {
    render(<EditalCard edital={mockEdital} onAprovar={() => {}} />)
    expect(screen.getByRole('heading', { name: /edital 01\/2026/i })).toBeInTheDocument()
    expect(screen.getByText(/publicado/i)).toBeInTheDocument()
  })

  it('dispara onAprovar ao clicar no botão', async () => {
    const user = userEvent.setup()
    const onAprovar = vi.fn()
    render(<EditalCard edital={mockEdital} onAprovar={onAprovar} />)
    await user.click(screen.getByRole('button', { name: /aprovar/i }))
    expect(onAprovar).toHaveBeenCalledWith('ed-001')
  })

  it('esconde botão aprovar se status !== publicado', () => {
    render(<EditalCard edital={{ ...mockEdital, status: 'rascunho' }} onAprovar={() => {}} />)
    expect(screen.queryByRole('button', { name: /aprovar/i })).not.toBeInTheDocument()
  })
})
```

---

### 9.2 Testing Best Practices

**Instruction** (V4 §testing-requirements.testing-best-practices, type: numbered-list).

**Template content (V4 literal + adaptações):**

1. **Unit Tests**: testar componentes individualmente em isolamento.
2. **Integration Tests**: testar interações entre componentes.
3. **E2E Tests**: testar user flows críticos (usando Cypress ou Playwright).
4. **Coverage Goals**: mirar 80% de code coverage.
5. **Test Structure**: padrão Arrange-Act-Assert.
6. **Mock External Dependencies**: API calls, routing, state management.
7. **Visual Regression** (opcional): Chromatic / Percy para catálogos Storybook (projetos com design system ativo).
8. **Accessibility Tests**: `jest-axe` / `vitest-axe` em smoke suite; avaliar WCAG AA.
9. **AAA por teste**: cada teste segue Arrange (setup), Act (interação), Assert (verificação) — um único comportamento por teste.
10. **Test data via factories**: evitar hardcoded IDs em múltiplos tests; usar fishery/test-data-bot ou equivalente.

---

### 9.3 Test Location

**Template content:**

```
- **Unit/component tests**: co-localizados com componentes (`EditalCard.spec.tsx` ao lado de `EditalCard.tsx`) OU em `tests/unit/` espelhando `src/`.
- **E2E tests**: `tests/e2e/` (Playwright `*.spec.ts` ou Cypress `cypress/e2e/`).
- **Fixtures**: `tests/fixtures/`.
- **Visual regression**: gerenciado por Chromatic/Percy a partir de `*.stories.tsx` (sem arquivo local).
```

---

## 10. Environment Configuration

<!-- elicit: true -->
<!-- source: V4 front-end-architecture-tmpl §environment-configuration -->

**Instruction for agent** (V4 §environment-configuration): listar variáveis de ambiente requeridas baseadas no framework escolhido. Mostrar formato e naming conventions apropriados.

**Regras**:
- **Nunca** hardcode segredos; variáveis **públicas** (expostas ao browser) DEVEM ter prefixo adequado (`NEXT_PUBLIC_*` / `VITE_*` / `NUXT_PUBLIC_*` / `REACT_APP_*`).
- Variáveis **privadas** (acessíveis só em server runtime / build-time) sem prefixo público.
- Documentar **tipo**, **obrigatoriedade**, **exemplo**, **onde é consumida**.

**Template content (exemplo Next.js; adaptar):**

```dotenv
# .env.example — versionado; .env.local NÃO versionado

# Public (expostas ao browser)
NEXT_PUBLIC_API_URL=https://api.exemplo.com
NEXT_PUBLIC_APP_ENV=development    # development | staging | production
NEXT_PUBLIC_SENTRY_DSN=            # opcional (error tracking frontend)
NEXT_PUBLIC_POSTHOG_KEY=           # opcional (analytics)

# Private (apenas server-side / build-time)
SESSION_SECRET=                    # obrigatório — sessões server-rendered
DATABASE_URL=                      # só se Next API routes acessam DB direto (evitar; preferir backend)
NEXTAUTH_SECRET=                   # se Next-Auth
NEXTAUTH_URL=                      # se Next-Auth
```

**Tabela de referência rápida:**

| Var | Tipo | Obrigatória | Exemplo | Consumida em |
|-----|------|-------------|---------|--------------|
| NEXT_PUBLIC_API_URL | URL | Sim | https://api.x.com | `src/services/api/client.ts` |
| NEXT_PUBLIC_APP_ENV | enum | Sim | production | providers, feature flags |
| SESSION_SECRET | string ≥32 | Sim | (random) | `src/lib/auth.ts` |

---

## 11. Frontend Developer Standards

<!-- source: V4 front-end-architecture-tmpl §frontend-developer-standards -->

**Escopo**: coding standards específicos de frontend. Coding standards backend ficam em `SOFTWARE_ARCHITECTURE.md §11 Coding Standards`. Regras cross-stack (ex.: nunca commitar secrets) vivem no backend e são referenciadas aqui.

---

### 11.1 Critical Coding Rules

<!-- elicit: true -->

**Instruction for agent** (V4 §frontend-developer-standards.critical-coding-rules): listar regras essenciais para prevenir erros comuns de AI agents, tanto universais quanto específicas do framework.

**Template content (exemplos — Arthur adapta ao framework; obter confirmação do usuário por regra):**

```
- **No console.log em produção**: usar logger / Sentry breadcrumb. Lint regra `no-console: ['error', { allow: ['warn', 'error'] }]`.
- **Componentes funcionais com TS**: nada de class components novos (React); sempre com `interface Props` explícita.
- **Hooks rules (React)**: hooks sempre no top-level do componente/custom hook; nunca condicional; nomear custom hooks com prefixo `use`.
- **Sem `any` fora de fronteiras externas**: `unknown` + type guard > `any`. Se `any` for necessário, comentar `// eslint-disable-next-line @typescript-eslint/no-explicit-any -- motivo`.
- **Imports absolutos via alias**: `@/components/...` (configurado no tsconfig/paths), nunca `../../../`.
- **Accessibility default**: todo componente interativo custom deve ter role + keyboard navigation + aria-labels adequadas; preferir primitivos Radix/react-aria como base.
- **Correlation ID propagação**: todo request HTTP propaga `X-Correlation-ID` (ver §6.2). Frontend gera UUID se ausente.
- **Sem secrets em env NEXT_PUBLIC_***: qualquer valor com prefixo público é **visível no browser**. Se for secreto, NÃO usa prefixo público.
- **Router guards SSR-safe**: não acessar `window`/`document` fora de `useEffect` ou `onMounted`; em Next, usar `'use client'` explicitamente.
- **Memoization justificada**: `useMemo`/`useCallback` apenas quando perf perfil comprova ganho; não como default.
- **Error boundaries**: toda rota top-level (layout/page) tem Error Boundary; erros não tratados fallback para tela amigável + Sentry.
- **i18n from day 1**: toda string visível ao usuário passa por camada i18n (mesmo que só PT-BR inicialmente); evita retrabalho futuro.
```

---

### 11.2 Quick Reference

**Instruction for agent** (V4 §frontend-developer-standards.quick-reference): cheat sheet framework-específico com:
- Comandos comuns (dev server, build, test).
- Import patterns principais.
- File naming conventions.
- Padrões e utilitários específicos do projeto.

**Template content (exemplo Next.js + pnpm; adaptar):**

```bash
# Comandos
pnpm dev                     # dev server (Turbopack)
pnpm build                   # build produção
pnpm start                   # serve build
pnpm test                    # Vitest unit
pnpm test:e2e                # Playwright
pnpm lint                    # ESLint
pnpm typecheck               # tsc --noEmit
pnpm storybook               # Storybook dev
```

```typescript
// Imports principais
import { useEditaisStore } from '@/stores/editais-store'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import type { Edital } from '@/types/edital.types'

// File naming (cheat sheet)
// - Components:      PascalCase.tsx      → EditalCard.tsx
// - Hooks:           useCamelCase.ts     → useEditalStatus.ts
// - Services:        kebab.service.ts    → edital-api.service.ts
// - Stores:          kebab-store.ts      → editais-store.ts
// - Types:           kebab.types.ts      → edital.types.ts
// - Tests:           source + .spec      → EditalCard.spec.tsx
// - Stories:         source + .stories   → EditalCard.stories.tsx

// Padrões de projeto
// - Data fetching:   useQuery + service layer (nunca fetch direto em componente)
// - State share:     store global p/ cross-route; useState p/ local; Context p/ provider-scoped
// - Forms:           React Hook Form + Zod schema (validação sync com backend)
// - Navigation:      useRouter() do Next (App Router) ou <Link>
```

---

## 12. Cross-reference: SOFTWARE_ARCHITECTURE.md

**Seções do backend que complementam este documento** (ler como contexto obrigatório):

| Seção backend | Complementa frontend | Motivo |
|----------------|----------------------|--------|
| SA §1 Introduction + §2 High Level | FE §1 Template and Framework Selection | Relação entre documentos + repo layout |
| SA §3 Tech Stack | FE §2 Frontend Tech Stack | Cross-stack: linguagem, package manager, build targets, versões pinadas |
| SA §6 REST API Spec | FE §6 API Integration | Endpoints, schemas, auth, error codes |
| SA §8 Source Tree | FE §3 Project Structure | Pasta top-level `packages/web/` decidida no backend; interior no frontend |
| SA §10 Error Handling Strategy | FE §6.2 API Client Configuration + §11.1 Critical Coding Rules | Correlation ID, retry/timeout, error translation |
| SA §11 Coding Standards (backend) | FE §11 Frontend Developer Standards | Regras cross-stack (secrets, logging, naming) herdadas; frontend adiciona regras UI-específicas |
| SA §13 Security | FE §11.1 (CSP, XSS, secrets em env público) | Security cross-stack decidida no backend; frontend aplica CSP/sanitization/token handling |
| SA §12 Test Strategy (backend) | FE §9 Testing Requirements | Cobertura distribuída: backend foca unit+integration+e2e API; frontend foca component+e2e UI+visual |

---

## 13. Next Steps / Consumo por Agentes Downstream

Este documento será consumido por:

- **Scrum Master (Fase II.2b)** → usa este documento + `SOFTWARE_ARCHITECTURE.md` + `IMPLEMENTATION_MAP.yaml` + `READINESS_REPORT.md` para escrever stories frontend self-contained.
- **Desenvolvedor frontend (Fase II.2b)** → lê **story + devLoadAlwaysFiles** (tipicamente §2 Tech Stack, §3 Project Structure, §4 Component Standards, §11 Developer Standards — via sharding). Nunca lê arquitetura completa diretamente.
- **QA de Código frontend (Fase II.2b)** → usa §9 Testing Requirements como referência normativa.
- **Guardião de Linguagem Ubíqua (Lexicon)** → lê §4.2 Naming Conventions para sync com TERMINOLOGY_MAP.yaml.
- **Arquiteto de Software (Arthur, reentrada)** → capability AM para atualização incremental (ex.: novo bounded context → novo store + serviços); capability IR para re-validação.

**Próximo passo imediato sugerido**: após aprovação deste documento **e** do `SOFTWARE_ARCHITECTURE.md`, executar capability **IR** para gerar `READINESS_REPORT.md` cobrindo ambos documentos.

---

**Fim do template frontend.**

**Total de seções**: 11 (§0 pré-condição + §1–§11 + §12 cross-ref + §13 next steps).
**Seções com `elicit: true`**: 9 (§1.1 Starter, §2, §3, §4, §5, §6, §7, §8, §9, §10, §11.1).
**Versão do template**: 1.0 (draft — 2026-04-19).
**Derivado de**: BMAD V4 `front-end-architecture-tmpl.yaml` v2.0.
**Complemento obrigatório**: `DRAFT_SOFTWARE_ARCHITECTURE-template.md` (escopo backend/sistema).
