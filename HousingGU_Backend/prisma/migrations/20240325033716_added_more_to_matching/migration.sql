/*
  Warnings:

  - Added the required column `RejectedRequest` to the `Matched` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `matched` ADD COLUMN `RejectedRequest` BOOLEAN NOT NULL;
