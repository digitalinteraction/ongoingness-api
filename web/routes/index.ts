import { Express } from 'express';

import { AuthRouter } from './api/auth';
import { UserRouter } from './api/user';
import { DeviceRouter } from './api/devices';
import { MediaRouter } from './api/media';

/**
 * [use description]
 * @return       [description]
 * @param app
 */
export function addRoutes(app: Express): Express {
  app.use('/api/auth', new AuthRouter().getRouter());
  app.use('/api/user', new UserRouter().getRouter());
  app.use('/api/devices', new DeviceRouter().getRouter());
  app.use('/api/media', new MediaRouter().getRouter());
  return app;
}
