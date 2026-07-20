import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// 글은 src/content/blog/*.md (또는 .mdx) 파일 하나 = 포스트 하나.
// 프론트매터 스키마. AI 가 글 쓸 때 아래 필드만 채우면 된다.
const blog = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string().optional(),
    pubDate: z.coerce.date(),
    updatedDate: z.coerce.date().optional(),
    tags: z.array(z.string()).default([]),
    // draft: true 면 목록/빌드에서 제외 (초안 보관용)
    draft: z.boolean().default(false),
  }),
});

export const collections = { blog };
