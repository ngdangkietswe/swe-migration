create database "SweTask";
\connect "SweTask";
create schema swetask;
alter database "SweTask" set search_path to swetask;
create extension if not exists pgcrypto;