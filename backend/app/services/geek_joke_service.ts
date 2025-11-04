import axios, { AxiosError } from 'axios'

export default class GeekJokeService {
  private readonly apiUrl = 'https://geek-jokes.sameerkumar.website/api?format=json'
  private readonly timeout = 5000 // 5 segundos

  /**
   * Busca uma piada aleatória da API Geek Joke
   * @returns Objeto com a propriedade 'joke' contendo a piada
   * @throws Error se a requisição falhar
   */
  async getRandomJoke(): Promise<{ joke: string }> {
    try {
      const response = await axios.get<{ joke: string }>(this.apiUrl, {
        timeout: this.timeout,
      })

      if (!response.data || !response.data.joke) {
        throw new Error('Invalid response format from Geek Joke API')
      }

      return {
        joke: response.data.joke,
      }
    } catch (error) {
      if (error instanceof AxiosError) {
        if (error.code === 'ECONNABORTED') {
          throw new Error('Request timeout: Geek Joke API took too long to respond')
        }
        if (error.response) {
          throw new Error(
            `Geek Joke API error: ${error.response.status} - ${error.response.statusText}`
          )
        }
        if (error.request) {
          throw new Error('Network error: Unable to reach Geek Joke API')
        }
      }
      throw new Error(`Failed to fetch joke: ${error instanceof Error ? error.message : 'Unknown error'}`)
    }
  }
}
