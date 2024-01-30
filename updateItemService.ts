import { Collection, Document } from "mongodb";
import { DateTime } from "luxon";
import _ from "lodash";
import { logger } from "config/logger";

export default class UpdateItemService {
  static async bulkUpdateRelationshipItems<T>(
    userId: string,
    targetCollection: Collection<Document>,
    relationshipObjects: UpdateRelationshipObject[]
  ): Promise<T[]> {
    const dateStamp = DateTime.now().toString();

    try {
      const existingEntries = await targetCollection
        .find({
          _id: { $in: relationshipObjects.map((o) => o.itemId) },
          userId,
        })
        .toArray();

      relationshipObjects
        .map((o) => o.inputObject)
        .forEach((input) => {
          Object.keys(input).forEach((key) => {
            if (!input[key]) {
              delete input[key];
            }
          });
        });

      const bulkUpdateObject = [];

      relationshipObjects.forEach((o) => {
        bulkUpdateObject.push({
          updateOne: {
            filter: {
              _id: o.itemId,
              userId,
            },
            update: {
              $set: { modifiedOn: dateStamp, ...o.inputObject },
            },
          },
        });
      });

      await targetCollection.bulkWrite(bulkUpdateObject);

      await Promise.all(
        relationshipObjects.map(async (o) => {
          await Promise.all(
            o.relationships.map(async (r) => {
              if (r.ids) {
                const bulkWriteObject = [];

                const item = existingEntries.find((e) => (e._id as unknown as string) === o.itemId);

                let currentIds: string[] = item[r.name];

                if (o.pushField === "workouts" && r.name === "exercises") {
                  currentIds = item.exerciseSets.map((s) => s.exercise);
                }

                const itemsToRemove = _.difference(currentIds, r.ids);
                const itemsToAdd = _.difference(r.ids, currentIds);

                if (itemsToRemove.length > 0) {
                  if (o.pushField === "exercises" && r.name === "workouts") {
                    bulkWriteObject.push({
                      updateMany: {
                        filter: {
                          _id: { $in: itemsToRemove },
                          userId,
                        },
                        update: {
                          $pull: { exerciseSets: { exercise: o.itemId } },
                          $set: { modifiedOn: dateStamp },
                        },
                      },
                    });
                  } else {
                    bulkWriteObject.push({
                      updateMany: {
                        filter: {
                          _id: { $in: itemsToRemove },
                          userId,
                        },
                        update: {
                          $pull: { [o.pushField]: o.itemId },
                          $set: { modifiedOn: dateStamp },
                        },
                      },
                    });
                  }
                }

                if (itemsToAdd.length > 0) {
                  if (o.pushField === "exercises" && r.name === "workouts") {
                    bulkWriteObject.push({
                      updateMany: {
                        filter: {
                          _id: { $in: itemsToAdd },
                          userId,
                        },
                        update: {
                          $push: {
                            exerciseSets: { exercise: o.itemId, sets: [] },
                          },
                          $set: { modifiedOn: dateStamp },
                        },
                      },
                    });
                  } else {
                    bulkWriteObject.push({
                      updateMany: {
                        filter: {
                          _id: { $in: itemsToAdd },
                          userId,
                        },
                        update: {
                          $push: { [o.pushField]: o.itemId },
                          $set: { modifiedOn: dateStamp },
                        },
                      },
                    });
                  }
                }

                if (bulkWriteObject.length > 0) {
                  await r.collection.bulkWrite(bulkWriteObject);
                }
              }
            })
          );
        })
      );

      const result = await targetCollection
        .find({
          _id: { $in: relationshipObjects.map((o) => o.itemId) },
          userId,
        })
        .toArray();

      return result as T[];
    } catch (error) {
      logger.error(error);
    }
  }
}

export interface UpdateRelationshipObject {
  itemId: string;
  inputObject: { [key: string]: any };
  pushField: string;
  relationships: {
    name: string;
    collection: Collection<Document>;
    ids: string[];
  }[];
}