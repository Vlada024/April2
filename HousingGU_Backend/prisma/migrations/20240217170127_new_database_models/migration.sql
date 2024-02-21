/*
  Warnings:

  - Added the required column `profilePicture` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `user` ADD COLUMN `PreferenceFilled` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `profilePicture` VARCHAR(191) NOT NULL;

-- CreateTable
CREATE TABLE `Preference` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `genderPreference` VARCHAR(191) NOT NULL,
    `bedtime` VARCHAR(191) NOT NULL,
    `tidiness` VARCHAR(191) NOT NULL,
    `smoking` VARCHAR(191) NOT NULL,
    `willingToLiveWithSmoker` BOOLEAN NOT NULL,
    `freeTime` VARCHAR(191) NOT NULL,
    `friendsVisit` VARCHAR(191) NOT NULL,
    `petsComfortable` VARCHAR(191) NOT NULL,
    `comfortable` VARCHAR(191) NOT NULL,
    `owned` VARCHAR(191) NOT NULL,
    `ownedPetsDescription` VARCHAR(191) NULL,
    `noiseLevel` VARCHAR(191) NOT NULL,
    `cookingFrequency` VARCHAR(191) NOT NULL,
    `sharingBelongings` VARCHAR(191) NOT NULL,
    `overnightGuests` VARCHAR(191) NOT NULL,
    `cleaningDuties` VARCHAR(191) NOT NULL,
    `workSchedule` VARCHAR(191) NOT NULL,
    `spaceUsage` VARCHAR(191) NOT NULL,
    `hobbies` VARCHAR(191) NOT NULL,
    `privacyExpectation` VARCHAR(191) NOT NULL,
    `allergiesValue` VARCHAR(191) NOT NULL,
    `allergiesDescription` VARCHAR(191) NULL,
    `longTermPlans` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
