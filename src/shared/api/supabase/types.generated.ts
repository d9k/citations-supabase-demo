export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          operationName?: string
          query?: string
          variables?: Json
          extensions?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      author: {
        Row: {
          approximate_years: boolean
          birth_town: number | null
          birth_year: number | null
          created_at: string
          created_by: number | null
          death_year: number | null
          id: number
          name_en: string
          name_orig: string | null
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string | null
          updated_by: number | null
        }
        Insert: {
          approximate_years?: boolean
          birth_town?: number | null
          birth_year?: number | null
          created_at?: string
          created_by?: number | null
          death_year?: number | null
          id?: number
          name_en: string
          name_orig?: string | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Update: {
          approximate_years?: boolean
          birth_town?: number | null
          birth_year?: number | null
          created_at?: string
          created_by?: number | null
          death_year?: number | null
          id?: number
          name_en?: string
          name_orig?: string | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "author_birth_town_fkey"
            columns: ["birth_town"]
            isOneToOne: false
            referencedRelation: "town"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "author_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "author_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      citation: {
        Row: {
          author_id: number
          created_at: string
          created_by: number | null
          event_id: number | null
          id: number
          original_language_text: string | null
          place_id: number | null
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          text_en: string | null
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string | null
          updated_by: number | null
          year: number | null
        }
        Insert: {
          author_id: number
          created_at?: string
          created_by?: number | null
          event_id?: number | null
          id?: number
          original_language_text?: string | null
          place_id?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          text_en?: string | null
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
          year?: number | null
        }
        Update: {
          author_id?: number
          created_at?: string
          created_by?: number | null
          event_id?: number | null
          id?: number
          original_language_text?: string | null
          place_id?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          text_en?: string | null
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
          year?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "citation_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "author"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citation_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citation_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "event"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citation_place_id_fkey"
            columns: ["place_id"]
            isOneToOne: false
            referencedRelation: "place"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citation_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      content_item: {
        Row: {
          created_at: string
          created_by: number | null
          id: number
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string | null
          updated_by: number | null
        }
        Insert: {
          created_at?: string
          created_by?: number | null
          id: number
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Update: {
          created_at?: string
          created_by?: number | null
          id?: number
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Relationships: []
      }
      country: {
        Row: {
          created_at: string
          created_by: number | null
          found_year: number | null
          id: number
          name_en: string
          name_orig: string | null
          next_rename_year: number | null
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string | null
          updated_by: number | null
        }
        Insert: {
          created_at?: string
          created_by?: number | null
          found_year?: number | null
          id?: number
          name_en?: string
          name_orig?: string | null
          next_rename_year?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Update: {
          created_at?: string
          created_by?: number | null
          found_year?: number | null
          id?: number
          name_en?: string
          name_orig?: string | null
          next_rename_year?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string | null
          updated_by?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "country_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "country_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      event: {
        Row: {
          created_at: string
          created_by: number | null
          end_month: number | null
          end_year: number | null
          id: number
          name_en: string
          name_orig: string | null
          place_id: number | null
          published: boolean | null
          published_at: string | null
          published_by: number | null
          start_month: number
          start_year: number
          table_name: string
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string
          updated_by: number | null
        }
        Insert: {
          created_at?: string
          created_by?: number | null
          end_month?: number | null
          end_year?: number | null
          id?: number
          name_en: string
          name_orig?: string | null
          place_id?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          start_month: number
          start_year: number
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Update: {
          created_at?: string
          created_by?: number | null
          end_month?: number | null
          end_year?: number | null
          id?: number
          name_en?: string
          name_orig?: string | null
          place_id?: number | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          start_month?: number
          start_year?: number
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "event_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_place_id_fkey"
            columns: ["place_id"]
            isOneToOne: false
            referencedRelation: "place"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      place: {
        Row: {
          created_at: string
          created_by: number | null
          id: number
          name_en: string
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          town_id: number
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string
          updated_by: number | null
        }
        Insert: {
          created_at?: string
          created_by?: number | null
          id?: number
          name_en?: string
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          town_id: number
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Update: {
          created_at?: string
          created_by?: number | null
          id?: number
          name_en?: string
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          town_id?: number
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "place_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "place_town_id_fkey"
            columns: ["town_id"]
            isOneToOne: false
            referencedRelation: "town"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "place_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      profile: {
        Row: {
          auth_user_id: string
          avatar_url: string | null
          created_at: string | null
          full_name: string | null
          id: number
          updated_at: string | null
          username: string | null
          website: string | null
        }
        Insert: {
          auth_user_id: string
          avatar_url?: string | null
          created_at?: string | null
          full_name?: string | null
          id?: number
          updated_at?: string | null
          username?: string | null
          website?: string | null
        }
        Update: {
          auth_user_id?: string
          avatar_url?: string | null
          created_at?: string | null
          full_name?: string | null
          id?: number
          updated_at?: string | null
          username?: string | null
          website?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "profile_auth_user_id_fkey"
            columns: ["auth_user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          }
        ]
      }
      town: {
        Row: {
          country_id: number
          created_at: string
          created_by: number | null
          id: number
          name_en: string
          name_orig: string | null
          published: boolean | null
          published_at: string | null
          published_by: number | null
          table_name: string
          unpublished_at: string | null
          unpublished_by: number | null
          updated_at: string
          updated_by: number | null
        }
        Insert: {
          country_id: number
          created_at?: string
          created_by?: number | null
          id?: number
          name_en: string
          name_orig?: string | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Update: {
          country_id?: number
          created_at?: string
          created_by?: number | null
          id?: number
          name_en?: string
          name_orig?: string | null
          published?: boolean | null
          published_at?: string | null
          published_by?: number | null
          table_name?: string
          unpublished_at?: string | null
          unpublished_by?: number | null
          updated_at?: string
          updated_by?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "town_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "country"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "town_created_by_fkey"
            columns: ["created_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "town_updated_by_fkey"
            columns: ["updated_by"]
            isOneToOne: false
            referencedRelation: "profile"
            referencedColumns: ["id"]
          }
        ]
      }
      trust: {
        Row: {
          end_at: string
          id: number
          trusts_whom: number
          who: number
        }
        Insert: {
          end_at?: string
          id?: number
          trusts_whom: number
          who: number
        }
        Update: {
          end_at?: string
          id?: number
          trusts_whom?: number
          who?: number
        }
        Relationships: []
      }
    }
    Views: {
      view_id_name: {
        Row: {
          id: number | null
          name: string | null
          short_name: string | null
          table_name: string | null
        }
        Relationships: []
      }
      view_rls_content_item: {
        Row: {
          deletable: boolean | null
          editable: boolean | null
          id: number | null
          table_name: string | null
        }
        Insert: {
          deletable?: never
          editable?: never
          id?: number | null
          table_name?: string | null
        }
        Update: {
          deletable?: never
          editable?: never
          id?: number | null
          table_name?: string | null
        }
        Relationships: []
      }
      view_rls_edit_for_table: {
        Row: {
          deletable: boolean | null
          editable: boolean | null
          id: number | null
          table_name: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      content_item_edit_protect_generated_fields: {
        Args: {
          new: unknown
          old: unknown
        }
        Returns: undefined
      }
      content_item_new_protect_generated_fields: {
        Args: {
          new: unknown
        }
        Returns: undefined
      }
      content_item_publish: {
        Args: {
          _table_name: string
          _id: number
        }
        Returns: undefined
      }
      content_item_unpublish: {
        Args: {
          _table_name: string
          _id: number
        }
        Returns: undefined
      }
      delete_claim: {
        Args: {
          uid: string
          claim: string
        }
        Returns: string
      }
      equal_or_both_null: {
        Args: {
          a: unknown
          b: unknown
        }
        Returns: boolean
      }
      fn_any_type: {
        Args: {
          r: Record<string, unknown>
        }
        Returns: Record<string, unknown>
      }
      get_claim: {
        Args: {
          uid: string
          claim: string
        }
        Returns: Json
      }
      get_claims: {
        Args: {
          uid: string
        }
        Returns: Json
      }
      get_my_claim: {
        Args: {
          claim: string
        }
        Returns: Json
      }
      get_my_claims: {
        Args: Record<PropertyKey, never>
        Returns: Json
      }
      is_claims_admin: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      permission_publish_check: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      permission_publish_get: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      protect_generated_field_from_change: {
        Args: {
          a: unknown
          b: unknown
          variable_name: string
        }
        Returns: undefined
      }
      protect_generated_field_from_init: {
        Args: {
          a: unknown
          variable_name: string
        }
        Returns: undefined
      }
      record_fill_created_by: {
        Args: {
          r: Record<string, unknown>
        }
        Returns: Record<string, unknown>
      }
      record_fill_updated_at: {
        Args: {
          r: Record<string, unknown>
        }
        Returns: Record<string, unknown>
      }
      record_fill_updated_by: {
        Args: {
          r: Record<string, unknown>
        }
        Returns: Record<string, unknown>
      }
      rls_authors_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_authors_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_check_delete_by_created_by: {
        Args: {
          created_by: number
          allow_trust?: boolean
          claim_check?: string
        }
        Returns: boolean
      }
      rls_check_edit_by_created_by: {
        Args: {
          created_by: number
          allow_trust?: boolean
          claim_check?: string
        }
        Returns: boolean
      }
      rls_citations_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_citations_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_content_item_check_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_content_item_check_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_events_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_events_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_places_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_places_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_profiles_edit:
        | {
            Args: {
              record: unknown
            }
            Returns: boolean
          }
        | {
            Args: {
              records: unknown[]
            }
            Returns: boolean
          }
      rls_towns_delete: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_towns_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      rls_trusts_edit: {
        Args: {
          record: unknown
        }
        Returns: boolean
      }
      set_claim: {
        Args: {
          uid: string
          claim: string
          value: Json
        }
        Returns: string
      }
      string_limit: {
        Args: {
          s: string
          max_length: number
        }
        Returns: string
      }
      temporary_fn: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  storage: {
    Tables: {
      buckets: {
        Row: {
          allowed_mime_types: string[] | null
          avif_autodetection: boolean | null
          created_at: string | null
          file_size_limit: number | null
          id: string
          name: string
          owner: string | null
          owner_id: string | null
          public: boolean | null
          updated_at: string | null
        }
        Insert: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id: string
          name: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Update: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id?: string
          name?: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Relationships: []
      }
      migrations: {
        Row: {
          executed_at: string | null
          hash: string
          id: number
          name: string
        }
        Insert: {
          executed_at?: string | null
          hash: string
          id: number
          name: string
        }
        Update: {
          executed_at?: string | null
          hash?: string
          id?: number
          name?: string
        }
        Relationships: []
      }
      objects: {
        Row: {
          bucket_id: string | null
          created_at: string | null
          id: string
          last_accessed_at: string | null
          metadata: Json | null
          name: string | null
          owner: string | null
          owner_id: string | null
          path_tokens: string[] | null
          updated_at: string | null
          version: string | null
        }
        Insert: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          version?: string | null
        }
        Update: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          version?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "objects_bucketId_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          }
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      can_insert_object: {
        Args: {
          bucketid: string
          name: string
          owner: string
          metadata: Json
        }
        Returns: undefined
      }
      extension: {
        Args: {
          name: string
        }
        Returns: string
      }
      filename: {
        Args: {
          name: string
        }
        Returns: string
      }
      foldername: {
        Args: {
          name: string
        }
        Returns: unknown
      }
      get_size_by_bucket: {
        Args: Record<PropertyKey, never>
        Returns: {
          size: number
          bucket_id: string
        }[]
      }
      search: {
        Args: {
          prefix: string
          bucketname: string
          limits?: number
          levels?: number
          offsets?: number
          search?: string
          sortcolumn?: string
          sortorder?: string
        }
        Returns: {
          name: string
          id: string
          updated_at: string
          created_at: string
          last_accessed_at: string
          metadata: Json
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (Database["public"]["Tables"] & Database["public"]["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (Database["public"]["Tables"] &
      Database["public"]["Views"])
  ? (Database["public"]["Tables"] &
      Database["public"]["Views"])[PublicTableNameOrOptions] extends {
      Row: infer R
    }
    ? R
    : never
  : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof Database["public"]["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof Database["public"]["Tables"]
  ? Database["public"]["Tables"][PublicTableNameOrOptions] extends {
      Insert: infer I
    }
    ? I
    : never
  : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof Database["public"]["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof Database["public"]["Tables"]
  ? Database["public"]["Tables"][PublicTableNameOrOptions] extends {
      Update: infer U
    }
    ? U
    : never
  : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof Database["public"]["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof Database["public"]["Enums"]
  ? Database["public"]["Enums"][PublicEnumNameOrOptions]
  : never
