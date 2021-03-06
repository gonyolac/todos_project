PGDMP     -                    u           todos    9.6.2    9.6.2     h	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            i	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            j	           1262    17911    todos    DATABASE     w   CREATE DATABASE todos WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE todos;
             Caloy    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             Caloy    false            k	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  Caloy    false    3                        3079    12655    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            l	           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    17914    lists    TABLE     H   CREATE TABLE lists (
    id integer NOT NULL,
    name text NOT NULL
);
    DROP TABLE public.lists;
       public         Caloy    false    3            �            1259    17912    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       Caloy    false    186    3            m	           0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       Caloy    false    185            �            1259    17927    todos    TABLE     �   CREATE TABLE todos (
    id integer NOT NULL,
    name text NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    list_id integer NOT NULL
);
    DROP TABLE public.todos;
       public         Caloy    false    3            �            1259    17925    todos_id_seq    SEQUENCE     n   CREATE SEQUENCE todos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.todos_id_seq;
       public       Caloy    false    188    3            n	           0    0    todos_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE todos_id_seq OWNED BY todos.id;
            public       Caloy    false    187            �           2604    17917    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       Caloy    false    185    186    186            �           2604    17930    todos id    DEFAULT     V   ALTER TABLE ONLY todos ALTER COLUMN id SET DEFAULT nextval('todos_id_seq'::regclass);
 7   ALTER TABLE public.todos ALTER COLUMN id DROP DEFAULT;
       public       Caloy    false    187    188    188            c	          0    17914    lists 
   TABLE DATA               "   COPY lists (id, name) FROM stdin;
    public       Caloy    false    186   �       o	           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       Caloy    false    185            e	          0    17927    todos 
   TABLE DATA               6   COPY todos (id, name, completed, list_id) FROM stdin;
    public       Caloy    false    188   �       p	           0    0    todos_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('todos_id_seq', 1, false);
            public       Caloy    false    187            �           2606    17924    lists lists_name_key 
   CONSTRAINT     H   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_name_key UNIQUE (name);
 >   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_name_key;
       public         Caloy    false    186    186            �           2606    17922    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         Caloy    false    186    186            �           2606    17936    todos todos_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY todos
    ADD CONSTRAINT todos_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.todos DROP CONSTRAINT todos_pkey;
       public         Caloy    false    188    188            �           2606    17937    todos todos_list_id_fkey    FK CONSTRAINT     i   ALTER TABLE ONLY todos
    ADD CONSTRAINT todos_list_id_fkey FOREIGN KEY (list_id) REFERENCES lists(id);
 B   ALTER TABLE ONLY public.todos DROP CONSTRAINT todos_list_id_fkey;
       public       Caloy    false    2281    186    188            c	      x������ � �      e	      x������ � �     