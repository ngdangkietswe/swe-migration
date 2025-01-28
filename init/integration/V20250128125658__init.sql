create database "SweIntegration";
\connect "SweIntegration";
create schema sweintegration;
alter database "SweIntegration" set search_path to sweintegration;
create extension if not exists pgcrypto;