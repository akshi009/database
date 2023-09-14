/*
  Warnings:

  - The primary key for the `Tweets_retweets` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `id` on the `Tweets_retweets` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - You are about to alter the column `user_id` on the `Tweets_retweets` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - The primary key for the `user` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `id` on the `user` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - The primary key for the `like` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `id` on the `like` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - You are about to alter the column `tweet_id` on the `like` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.
  - You are about to alter the column `user_id` on the `like` table. The data in that column could be lost. The data in that column will be cast from `String` to `Int`.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Tweets_retweets" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Tweets_retweets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Tweets_retweets" ("content", "id", "user_id") SELECT "content", "id", "user_id" FROM "Tweets_retweets";
DROP TABLE "Tweets_retweets";
ALTER TABLE "new_Tweets_retweets" RENAME TO "Tweets_retweets";
CREATE UNIQUE INDEX "Tweets_retweets_user_id_key" ON "Tweets_retweets"("user_id");
CREATE TABLE "new_user" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone_no" INTEGER
);
INSERT INTO "new_user" ("email", "id", "name", "phone_no") SELECT "email", "id", "name", "phone_no" FROM "user";
DROP TABLE "user";
ALTER TABLE "new_user" RENAME TO "user";
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");
CREATE TABLE "new_like" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "tweet_id" INTEGER NOT NULL,
    CONSTRAINT "like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "like_tweet_id_fkey" FOREIGN KEY ("tweet_id") REFERENCES "Tweets_retweets" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_like" ("id", "tweet_id", "user_id") SELECT "id", "tweet_id", "user_id" FROM "like";
DROP TABLE "like";
ALTER TABLE "new_like" RENAME TO "like";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
