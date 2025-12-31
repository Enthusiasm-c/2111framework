---
name: react-patterns
description: React hooks and component best practices
category: tech-stack
---

# React Best Practices

## Hooks
```typescript
// useState
const [count, setCount] = useState(0);

// useEffect
useEffect(() => {
  // Side effect
  return () => {
    // Cleanup
  };
}, [dependency]);

// useMemo (expensive calculations)
const computed = useMemo(() => 
  expensiveCalc(data), 
  [data]
);

// useCallback (stable functions)
const handler = useCallback(() => {
  doSomething();
}, []);
```

## Component Patterns
```typescript
// Composition
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
  </CardHeader>
  <CardContent>Content</CardContent>
</Card>

// Conditional rendering
{isLoading ? <Spinner /> : <Content />}
{error && <ErrorMessage />}
{items?.length > 0 && <List items={items} />}
```

## Performance
- React.memo for pure components
- Keys in lists (stable IDs, not index)
- Lazy loading: `const Heavy = lazy(() => import('./Heavy'))`
