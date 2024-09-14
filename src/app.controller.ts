import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/addUser')
  addUser() {
    this.appService.addUser()
  }

  @Get('getUserList')
  getUserList() {
    return this.appService.getUserList();
  }
}
