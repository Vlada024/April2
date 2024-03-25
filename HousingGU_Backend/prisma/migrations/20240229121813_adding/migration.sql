/*
  Warnings:

  - A unique constraint covering the columns `[MatchedId]` on the table `Chat` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `MatchedId` to the `Chat` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `chat` ADD COLUMN `MatchedId` VARCHAR(191) NOT NULL;

-- CreateTable
CREATE TABLE `Matched` (
    `id` VARCHAR(191) NOT NULL,
    `MatchRequestedBy` VARCHAR(191) NOT NULL,
    `MatchRequestTo` VARCHAR(191) NOT NULL,
    `ApprovedRequest` BOOLEAN NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `Chat_MatchedId_key` ON `Chat`(`MatchedId`);

-- AddForeignKey
ALTER TABLE `Chat` ADD CONSTRAINT `Chat_MatchedId_fkey` FOREIGN KEY (`MatchedId`) REFERENCES `Matched`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Matched` ADD CONSTRAINT `Matched_MatchRequestedBy_fkey` FOREIGN KEY (`MatchRequestedBy`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
