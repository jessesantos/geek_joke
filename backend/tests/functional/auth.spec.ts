import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'

test.group('Auth - Login', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  test('deve fazer login com credenciais válidas', async ({ client, assert }) => {
    // Criar usuário de teste
    const User = (await import('#models/user')).default
    await User.create({
      email: 'cliente@incuca.com.br',
      password: 'seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga',
    })

    const response = await client.post('/auth/login').json({
      email: 'cliente@incuca.com.br',
      password: 'seumamesapossuirtrespernaschamadasqualidadeprecobaixoevelocidadeelaseriacapenga',
    })

    response.assertStatus(200)
    assert.exists(response.body().token)
    assert.exists(response.body().user)
    assert.equal(response.body().user.email, 'cliente@incuca.com.br')
  })

  test('deve falhar ao fazer login com email inválido', async ({ client }) => {
    const response = await client.post('/auth/login').json({
      email: 'emailinvalido@teste.com',
      password: 'senhaqualquer',
    })

    response.assertStatus(401)
  })

  test('deve falhar ao fazer login com senha inválida', async ({ client }) => {
    // Criar usuário de teste
    const User = (await import('#models/user')).default
    await User.create({
      email: 'teste@teste.com',
      password: 'senhaCorreta123',
    })

    const response = await client.post('/auth/login').json({
      email: 'teste@teste.com',
      password: 'senhaErrada',
    })

    response.assertStatus(401)
  })

  test('deve falhar ao fazer login sem credenciais', async ({ client }) => {
    const response = await client.post('/auth/login').json({})

    response.assertStatus(400)
  })
})

test.group('Auth - Me (Usuário Autenticado)', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  test('deve retornar dados do usuário autenticado', async ({ client, assert }) => {
    // Criar usuário e fazer login
    const User = (await import('#models/user')).default
    const user = await User.create({
      email: 'teste@teste.com',
      password: 'senha123456',
    })

    const token = await User.accessTokens.create(user)

    const response = await client
      .get('/auth/me')
      .header('Authorization', `Bearer ${token.value!.release()}`)

    response.assertStatus(200)
    assert.equal(response.body().user.email, 'teste@teste.com')
  })

  test('deve falhar ao acessar /me sem token', async ({ client }) => {
    const response = await client.get('/auth/me')

    response.assertStatus(401)
  })

  test('deve falhar ao acessar /me com token inválido', async ({ client }) => {
    const response = await client
      .get('/auth/me')
      .header('Authorization', 'Bearer token_invalido_123')

    response.assertStatus(401)
  })
})

test.group('Auth - Logout', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  test('deve fazer logout com sucesso', async ({ client }) => {
    // Criar usuário e fazer login
    const User = (await import('#models/user')).default
    const user = await User.create({
      email: 'teste@teste.com',
      password: 'senha123456',
    })

    const token = await User.accessTokens.create(user)

    const response = await client
      .post('/auth/logout')
      .header('Authorization', `Bearer ${token.value!.release()}`)

    response.assertStatus(200)
    response.assertBodyContains({
      message: 'Logged out successfully',
    })
  })

  test('deve falhar ao fazer logout sem token', async ({ client }) => {
    const response = await client.post('/auth/logout')

    response.assertStatus(401)
  })
})
