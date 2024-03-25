/*
  Warnings:

  - Added the required column `RequestedByMatchPercentage` to the `Matched` table without a default value. This is not possible if the table is not empty.
  - Added the required column `RequestedByName` to the `Matched` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `matched` ADD COLUMN `RequestedByMatchPercentage` VARCHAR(191) NOT NULL,
    ADD COLUMN `RequestedByName` VARCHAR(191) NOT NULL;
