import { BaseSeeder } from '@adonisjs/lucid/seeders'
import User from '#models/user'

export default class extends BaseSeeder {
  async run() {
    // Create default user for testing
    await User.create({
      email: 'cliente@incuca.com.br',
      password: 'seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga',
      fullName: 'Cliente Padrão',
    })
  }
}