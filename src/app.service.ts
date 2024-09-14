import { Injectable } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { randomUUID } from 'crypto';


@Injectable()
export class AppService {

  async addUser() {
    let client = new PrismaClient()
    let random = randomUUID()
    let result = client.user.create({
      data: {
        name: random,
        email: `${random}@163.com`
      }
    })
    return result;
  }

  async getUserList() {
    let client = new PrismaClient()
    let result = client.user.findMany()
    return result;
  }
}