/*
  Warnings:

  - Added the required column `type` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `user` ADD COLUMN `aboutMe` VARCHAR(191) NULL,
    ADD COLUMN `desc` VARCHAR(191) NULL,
    ADD COLUMN `type` VARCHAR(191) NOT NULL;
