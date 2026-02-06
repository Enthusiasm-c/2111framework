---
name: shadcn-ui-usage
description: Complete guide for shadcn/ui component library
model: sonnet
---

# shadcn/ui - Complete Usage Guide

## Installation & Setup

### Automatic Setup
```bash
npx shadcn@latest init
```

### components.json Configuration
```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "app/globals.css",
    "baseColor": "slate",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui"
  }
}
```

### Essential Utility (lib/utils.ts)
```typescript
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## Component Installation

```bash
# Individual
npx shadcn@latest add button
npx shadcn@latest add dialog

# Multiple at once
npx shadcn@latest add button dialog form card
```

## Core Components

### Button
```typescript
import { Button } from "@/components/ui/button"

// Variants
<Button>Default</Button>
<Button variant="destructive">Destructive</Button>
<Button variant="outline">Outline</Button>
<Button variant="secondary">Secondary</Button>
<Button variant="ghost">Ghost</Button>
<Button variant="link">Link</Button>

// Sizes
<Button size="default">Default</Button>
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
<Button size="icon"><Icon /></Button>

// As Link
<Button asChild>
  <Link href="/dashboard">Dashboard</Link>
</Button>
```

### Form (React Hook Form + Zod)
```typescript
"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import {
  Form, FormControl, FormField, FormItem,
  FormLabel, FormMessage,
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"

const formSchema = z.object({
  email: z.string().email("Invalid email"),
  password: z.string().min(8, "Min 8 characters"),
})

export function LoginForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: "", password: "" },
  })

  function onSubmit(values: z.infer<typeof formSchema>) {
    console.log(values)
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        <Button type="submit">Submit</Button>
      </form>
    </Form>
  )
}
```

### Dialog
```typescript
import {
  Dialog, DialogContent, DialogDescription,
  DialogHeader, DialogTitle, DialogTrigger,
} from "@/components/ui/dialog"

<Dialog>
  <DialogTrigger asChild>
    <Button variant="outline">Open</Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Title</DialogTitle>
      <DialogDescription>Description</DialogDescription>
    </DialogHeader>
    <div>Content here</div>
  </DialogContent>
</Dialog>

// Controlled
const [open, setOpen] = useState(false)
<Dialog open={open} onOpenChange={setOpen}>
```

### Toast (Sonner)
```typescript
// app/layout.tsx
import { Toaster } from "@/components/ui/sonner"

export default function Layout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Toaster />
      </body>
    </html>
  )
}

// Usage
import { toast } from "sonner"

toast("Event created")
toast.success("Success!")
toast.error("Error!")
toast("Action", {
  action: { label: "Undo", onClick: () => {} },
})
```

### Data Table (TanStack Table)
```typescript
"use client"

import {
  ColumnDef, flexRender, getCoreRowModel,
  getPaginationRowModel, useReactTable,
} from "@tanstack/react-table"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"

interface DataTableProps<T> {
  columns: ColumnDef<T>[]
  data: T[]
}

export function DataTable<T>({ columns, data }: DataTableProps<T>) {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
  })

  return (
    <Table>
      <TableHeader>
        {table.getHeaderGroups().map(headerGroup => (
          <TableRow key={headerGroup.id}>
            {headerGroup.headers.map(header => (
              <TableHead key={header.id}>
                {flexRender(header.column.columnDef.header, header.getContext())}
              </TableHead>
            ))}
          </TableRow>
        ))}
      </TableHeader>
      <TableBody>
        {table.getRowModel().rows.map(row => (
          <TableRow key={row.id}>
            {row.getVisibleCells().map(cell => (
              <TableCell key={cell.id}>
                {flexRender(cell.column.columnDef.cell, cell.getContext())}
              </TableCell>
            ))}
          </TableRow>
        ))}
      </TableBody>
    </Table>
  )
}
```

## Theming

### CSS Variables (Recommended)
```css
:root {
  --background: oklch(1 0 0);
  --foreground: oklch(0.141 0.005 285.823);
  --primary: oklch(0.21 0.006 285.885);
  --primary-foreground: oklch(0.985 0 0);
  --radius: 0.625rem;
}

.dark {
  --background: oklch(0.141 0.005 285.823);
  --foreground: oklch(0.985 0 0);
}
```

### Dark Mode Setup
```typescript
// components/theme-provider.tsx
"use client"
import { ThemeProvider as NextThemesProvider } from "next-themes"

export function ThemeProvider({ children, ...props }) {
  return <NextThemesProvider {...props}>{children}</NextThemesProvider>
}

// app/layout.tsx
<ThemeProvider attribute="class" defaultTheme="system" enableSystem>
  {children}
</ThemeProvider>
```

## Best Practices

### Composition with asChild
```typescript
// ✅ Correct
<Button asChild>
  <Link href="/dashboard">Dashboard</Link>
</Button>

// ❌ Avoid wrapping
<Link href="/dashboard">
  <Button>Dashboard</Button>
</Link>
```

### Controlled vs Uncontrolled
```typescript
// Controlled (you manage state)
const [open, setOpen] = useState(false)
<Dialog open={open} onOpenChange={setOpen}>

// Uncontrolled (component manages)
<Dialog>
```

### Accessibility
- Always use `aria-label` for icon-only buttons
- Use semantic HTML
- Test keyboard navigation (Tab, Enter, Escape)
- Ensure proper focus management
