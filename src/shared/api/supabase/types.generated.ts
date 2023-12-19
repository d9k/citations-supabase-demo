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
      authors: {
        Row: {
          approximate_years: boolean
          birth_town: number | null
          birth_year: number | null
          created_at: string
          death_year: number | null
          id: number
          lastname_name_patronymic: string
          updated_at: string
        }
        Insert: {
          approximate_years?: boolean
          birth_town?: number | null
          birth_year?: number | null
          created_at?: string
          death_year?: number | null
          id?: number
          lastname_name_patronymic: string
          updated_at?: string
        }
        Update: {
          approximate_years?: boolean
          birth_town?: number | null
          birth_year?: number | null
          created_at?: string
          death_year?: number | null
          id?: number
          lastname_name_patronymic?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "authors_birth_town_fkey"
            columns: ["birth_town"]
            isOneToOne: false
            referencedRelation: "town"
            referencedColumns: ["id"]
          }
        ]
      }
      citations: {
        Row: {
          author_id: number
          created_at: string
          english_text: string | null
          event_id: number | null
          id: number
          original_language_text: string | null
          place_id: number | null
          updated_at: string
          year: number | null
        }
        Insert: {
          author_id: number
          created_at?: string
          english_text?: string | null
          event_id?: number | null
          id?: number
          original_language_text?: string | null
          place_id?: number | null
          updated_at?: string
          year?: number | null
        }
        Update: {
          author_id?: number
          created_at?: string
          english_text?: string | null
          event_id?: number | null
          id?: number
          original_language_text?: string | null
          place_id?: number | null
          updated_at?: string
          year?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "citations_author_id_fkey"
            columns: ["author_id"]
            isOneToOne: false
            referencedRelation: "authors"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citations_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "event"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "citations_place_id_fkey"
            columns: ["place_id"]
            isOneToOne: false
            referencedRelation: "place"
            referencedColumns: ["id"]
          }
        ]
      }
      countries: {
        Row: {
          created_at: string
          found_year: number | null
          id: number
          name: string
          next_rename_year: number | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string
          found_year?: number | null
          id?: number
          name: string
          next_rename_year?: number | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string
          found_year?: number | null
          id?: number
          name?: string
          next_rename_year?: number | null
          updated_at?: string | null
        }
        Relationships: []
      }
      event: {
        Row: {
          created_at: string
          end_month: number | null
          end_year: number | null
          id: number
          name: string
          place_id: number | null
          start_month: number
          start_year: number
          updated_at: string
        }
        Insert: {
          created_at?: string
          end_month?: number | null
          end_year?: number | null
          id?: number
          name: string
          place_id?: number | null
          start_month: number
          start_year: number
          updated_at?: string
        }
        Update: {
          created_at?: string
          end_month?: number | null
          end_year?: number | null
          id?: number
          name?: string
          place_id?: number | null
          start_month?: number
          start_year?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "event_place_id_fkey"
            columns: ["place_id"]
            isOneToOne: false
            referencedRelation: "place"
            referencedColumns: ["id"]
          }
        ]
      }
      place: {
        Row: {
          created_at: string
          id: number
          name: string
          town_id: number
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: number
          name?: string
          town_id: number
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: number
          name?: string
          town_id?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "place_town_id_fkey"
            columns: ["town_id"]
            isOneToOne: false
            referencedRelation: "town"
            referencedColumns: ["id"]
          }
        ]
      }
      profiles: {
        Row: {
          auth_user_id: string
          avatar_url: string | null
          full_name: string | null
          id: number
          updated_at: string | null
          username: string | null
          website: string | null
        }
        Insert: {
          auth_user_id: string
          avatar_url?: string | null
          full_name?: string | null
          id?: number
          updated_at?: string | null
          username?: string | null
          website?: string | null
        }
        Update: {
          auth_user_id?: string
          avatar_url?: string | null
          full_name?: string | null
          id?: number
          updated_at?: string | null
          username?: string | null
          website?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "profiles_id_fkey"
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
          id: number
          name: string
          updated_at: string
        }
        Insert: {
          country_id: number
          created_at?: string
          id?: number
          name: string
          updated_at?: string
        }
        Update: {
          country_id?: number
          created_at?: string
          id?: number
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "town_country_id_fkey"
            columns: ["country_id"]
            isOneToOne: false
            referencedRelation: "countries"
            referencedColumns: ["id"]
          }
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      delete_claim: {
        Args: {
          uid: string
          claim: string
        }
        Returns: string
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
      set_claim: {
        Args: {
          uid: string
          claim: string
          value: Json
        }
        Returns: string
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
