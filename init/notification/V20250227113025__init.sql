create database "SweNotification";
\connect "SweNotification";
create schema swenotification;
alter database "SweNotification" set search_path to swenotification;
create extension if not exists pgcrypto;