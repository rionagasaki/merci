/* eslint-disable operator-linebreak */
import * as aws from "aws-sdk";
import { Request, Response } from "express";
import { v4 as uuidv4 } from "uuid";
import { updateUserCallingStatus } from "./index";

aws.config.update({
  credentials: new aws.Credentials(
    "AKIAVKGQQLPJN4TWCUZE",
    "J7bvbo8UbVglFAeSQ7QnnoKFvrWuVb090k3J1+LR"
  ),
  region: "us-east-1",
});

const chime = new aws.ChimeSDKMeetings({ region: "us-east-1" });
chime.endpoint = new aws.Endpoint(
  "https://meetings-chime.us-east-1.amazonaws.com"
);

const generateUUID = (): string => {
  return uuidv4();
};

export const createOrJoinMeeting = async (req: Request, res: Response) => {
  const requestToken =
    // eslint-disable-next-line max-len
    typeof req.body.data.channelId === "string"
      ? req.body.data.channelId
      : generateUUID();

  let meeting;
  let attendee;
  if (!req.body.data.channelId) {
    try {
      const requestParams = {
        ClientRequestToken: requestToken,
        ExternalMeetingId: requestToken,
        MediaRegion: "us-east-1",
      };

      meeting = await chime.createMeeting(requestParams).promise();
      attendee = await chime
        .createAttendee({
          MeetingId: meeting.Meeting?.MeetingId as string,
          ExternalUserId: req.body.data.userId,
        })
        .promise();

      await updateUserCallingStatus(
        req.body.data.userId,
        meeting.Meeting?.MeetingId as string
      );

      res.status(200).json({
        data: {
          meeting: meeting,
          attendee: attendee,
        },
      });
    } catch (error) {
      console.error("Error creating or joining meeting:", error);
      res.status(500).send(`Failed to create or join meeting: ${error}`);
    }
  } else {
    try {
      meeting = await chime
        .getMeeting({
          MeetingId: req.body.data.channelId,
        })
        .promise();

      attendee = await chime
        .createAttendee({
          MeetingId: req.body.data.channelId,
          ExternalUserId: req.body.data.userId,
        })
        .promise();
      // eslint-disable-next-line max-len
      await updateUserCallingStatus(
        req.body.data.userId,
        req.body.data.channelId
      );

      res.status(200).json({
        data: {
          meeting: meeting,
          attendee: attendee,
        },
      });
    } catch (error: any) {
      res.status(500).send(`Failed to create or join meeting: ${error}`);
    }
  }
};

export const checkMeeting = async (
  channelId: string,
  errorCallback: (err: any) => void
) => {
  try {
    await chime
      .getMeeting({
        MeetingId: channelId,
      })
      .promise();
  } catch (error) {
    errorCallback(error);
  }
};

export const deleteMeeting = async (req: Request, res: Response) => {
  try {
    await chime
      .deleteMeeting({
        MeetingId: req.body.data.channelId,
      })
      .promise();
    await updateUserCallingStatus(req.body.data.userId, undefined);
    res.status(200).json({
      data: {
        message: "successfully end meeting",
      },
    });
  } catch (error) {
    console.error("Error end meeting:", error);
    res.status(500).send(`Failed to end meeting: ${error}`);
  }
};
