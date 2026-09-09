# Seed data

`words_seed.sqlite3` is the vocabulary from the pre-drift version of the app
(13 words, one per binyan plus a few Paal irregulars). Its `Words` table has the
same columns as the current `words_schema` table, so it can be imported with:

```sql
ATTACH 'words_seed.sqlite3' AS seed;
INSERT INTO words_schema (root, translate, type)
  SELECT root, translate, type FROM seed.Words;
```

Nothing in the app reads this file yet — the app's live database lives in the
platform's application-documents directory as `words.sqlite3`.
