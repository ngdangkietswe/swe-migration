create database "SweWorkflow";
\connect "SweWorkflow";
create schema sweworkflow;
alter database "SweWorkflow" set search_path to sweworkflow;
create extension if not exists pgcrypto;