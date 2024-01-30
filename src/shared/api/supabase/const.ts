export const CLAIM_PUBLISH = 'claim_publish';

export const COOKIE_NAME_SUPABASE_ACCESS_TOKEN = 'my-supabase-access-token';
export const COOKIE_NAME_SUPABASE_REFRESH_TOKEN = 'my-supabase-refresh-token';

export const COLUMN_NAME_EDITABLE = '_editable';
export const COLUMN_NAME_DELETABLE = '_deletable';
export const COLUMN_NAME_PUBLISHED = 'published';

export const COLUMNS_IDS = ['id'];
export const COLUMNS_AUTOGENERATED = [
  'id',
  'created_at',
  'created_by',
  'published_at',
  'published_by',
  'table_name',
  'updated_at',
  'updated_by',
  'unpublished_at',
  'unpublished_by',
  COLUMN_NAME_EDITABLE,
  COLUMN_NAME_DELETABLE,
  COLUMN_NAME_PUBLISHED,
];

export const COLUMNS_TO_ORDER_BY_DEFAULT = ['name_en', 'id'];

export const COLUMNS_SHOW_FIRST = [
  'id',
  COLUMN_NAME_EDITABLE,
  'name',
  'name_en',
  'name_orig',
  'text_en',
  'text_orig',
];
export const COLUMNS_SHOW_LAST = [
  'created_by',
  'updated_by',
  'created_at',
  'updated_at',
  COLUMN_NAME_DELETABLE,
  COLUMN_NAME_PUBLISHED,
];

export const TABLES_HIDDEN = ['content_item'];
