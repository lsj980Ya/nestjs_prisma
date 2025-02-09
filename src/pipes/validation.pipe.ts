import { ValidationPipe, ValidationError, BadRequestException } from '@nestjs/common';

export const GlobalValidationPipe = new ValidationPipe({
  whitelist: true,
  transform: true,
  disableErrorMessages: false,
  exceptionFactory: (errors: ValidationError[]) => {
    const result = errors.map((error) => ({
      property: error.property,
      message: error.constraints ?
        Object.values(error.constraints)[0] :
        '参数验证错误',
    }));
    throw new BadRequestException({
      statusCode: 400,
      message: '参数验证失败',
      errors: result,
    });
  },
});