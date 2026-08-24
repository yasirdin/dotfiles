# Merge settings.partial.json (second input) into settings.json (first input).
# Top-level keys from the partial win, except hooks: per-event arrays are
# concatenated and deduped so partial hooks coexist with hooks added by other
# tools instead of replacing them. unique makes re-runs idempotent.
(.[0].hooks // {}) as $a
| (.[1].hooks // {}) as $b
| (.[0] * .[1])
| if ($a + $b) == {} then .
  else .hooks = (($a + $b) | with_entries(
      .key as $k | .value = ((($a[$k] // []) + ($b[$k] // [])) | unique)
    ))
  end
