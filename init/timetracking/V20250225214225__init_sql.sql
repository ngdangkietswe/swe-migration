create database "SweTimeTracking";
\connect "SweTimeTracking";
create schema swetimetracking;
alter database "SweTimeTracking" set search_path to swetimetracking;
create extension if not exists pgcrypto;