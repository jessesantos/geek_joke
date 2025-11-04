import { test } from '@japa/runner'
import testUtils from '@adonisjs/core/services/test_utils'
import nock from 'nock'

test.group('Jokes API', (group) => {
  group.each.setup(() => testUtils.db().withGlobalTransaction())

  test('deve retornar uma piada quando autenticado', async ({ client, assert }) => {
    // Criar usuário e obter token
    const User = (await import('#models/user')).default
    const user = await User.create({
      email: 'teste@teste.com',
      password: 'senha123456',
    })

    const token = await User.accessTokens.create(user)

    // Mock da API externa de piadas
    nock('https://geek-jokes.sameerkumar.website')
      .get('/api')
      .query({ format: 'json' })
      .reply(200, {
        joke: 'Why do programmers prefer dark mode? Because light attracts bugs!',
      })

    const response = await client
      .get('/jokes/random')
      .header('Authorization', `Bearer ${token.value!.release()}`)

    response.assertStatus(200)
    assert.exists(response.body().joke)
    assert.isString(response.body().joke)
  })

  test('deve falhar ao buscar piada sem autenticação', async ({ client }) => {
    const response = await client.get('/jokes/random')

    response.assertStatus(401)
  })

  test('deve tratar erro da API externa corretamente', async ({ client }) => {
    // Criar usuário e obter token
    const User = (await import('#models/user')).default
    const user = await User.create({
      email: 'teste@teste.com',
      password: 'senha123456',
    })

    const token = await User.accessTokens.create(user)

    // Mock da API externa retornando erro
    nock('https://geek-jokes.sameerkumar.website')
      .get('/api')
      .query({ format: 'json' })
      .reply(500, 'Internal Server Error')

    const response = await client
      .get('/jokes/random')
      .header('Authorization', `Bearer ${token.value!.release()}`)

    response.assertStatus(500)
    response.assertBodyContains({
      error: 'Erro ao buscar piada',
    })
  })

  test('deve tratar timeout da API externa', async ({ client }) => {
    // Criar usuário e obter token
    const User = (await import('#models/user')).default
    const user = await User.create({
      email: 'teste@teste.com',
      password: 'senha123456',
    })

    const token = await User.accessTokens.create(user)

    // Mock da API externa com timeout
    nock('https://geek-jokes.sameerkumar.website')
      .get('/api')
      .query({ format: 'json' })
      .delayConnection(6000)
      .reply(200, { joke: 'Never gonna happen' })

    const response = await client
      .get('/jokes/random')
      .header('Authorization', `Bearer ${token.value!.release()}`)

    response.assertStatus(500)
    response.assertBodyContains({
      error: 'Erro ao buscar piada',
    })
  }).timeout(10000) // Aumentar timeout do teste
})

test.group('Jokes Service', () => {
  test('deve formatar resposta corretamente', async ({ assert }) => {
    // Mock da resposta da API
    nock('https://geek-jokes.sameerkumar.website')
      .get('/api')
      .query({ format: 'json' })
      .reply(200, {
        joke: 'Test joke',
      })

    const GeekJokeService = (await import('#services/geek_joke_service')).default
    const service = new GeekJokeService()
    const result = await service.getRandomJoke()

    assert.equal(result.joke, 'Test joke')
  })
})
