/*
  Warnings:

  - You are about to alter the column `willingToLiveWithSmoker` on the `preference` table. The data in that column could be lost. The data in that column will be cast from `TinyInt` to `VarChar(191)`.
  - Added the required column `billSplit` to the `Preference` table without a default value. This is not possible if the table is not empty.
  - Added the required column `conflictResolution` to the `Preference` table without a default value. This is not possible if the table is not empty.
  - Added the required column `specificGender` to the `Preference` table without a default value. This is not possible if the table is not empty.
  - Made the column `ownedPetsDescription` on table `preference` required. This step will fail if there are existing NULL values in that column.
  - Made the column `allergiesDescription` on table `preference` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `preference` ADD COLUMN `billSplit` VARCHAR(191) NOT NULL,
    ADD COLUMN `conflictResolution` VARCHAR(191) NOT NULL,
    ADD COLUMN `specificGender` VARCHAR(191) NOT NULL,
    MODIFY `willingToLiveWithSmoker` VARCHAR(191) NOT NULL,
    MODIFY `ownedPetsDescription` VARCHAR(191) NOT NULL,
    MODIFY `allergiesDescription` VARCHAR(191) NOT NULL;
