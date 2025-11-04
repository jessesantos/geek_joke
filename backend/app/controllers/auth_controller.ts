import User from '#models/user'
import { HttpContext } from '@adonisjs/core/http'
import hash from '@adonisjs/core/services/hash'

export default class AuthController {
  /**
   * Handle user login
   * POST /auth/login
   */
  async login({ request, response }: HttpContext) {
    try {
      // Validate request body
      const { email, password } = request.only(['email', 'password'])

      if (!email || !password) {
        return response.badRequest({
          error: 'Validation failed',
          message: 'Email and password are required',
        })
      }

      // Find user by email
      const user = await User.findBy('email', email)

      if (!user) {
        return response.unauthorized({
          error: 'Invalid credentials',
          message: 'The provided email or password is incorrect',
        })
      }

      // Verify password
      const isPasswordValid = await hash.verify(user.password, password)

      if (!isPasswordValid) {
        return response.unauthorized({
          error: 'Invalid credentials',
          message: 'The provided email or password is incorrect',
        })
      }

      // Generate access token
      const token = await User.accessTokens.create(user)

      return response.ok({
        token: token.value!.release(),
        user: {
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          createdAt: user.createdAt,
        },
      })
    } catch (error) {
      console.error('Login error:', error)
      return response.internalServerError({
        error: 'Login failed',
        message: error instanceof Error ? error.message : 'An unknown error occurred',
      })
    }
  }

  /**
   * Get authenticated user data
   * GET /auth/me
   */
  async me({ auth, response }: HttpContext) {
    try {
      const user = auth.user

      if (!user) {
        return response.unauthorized({
          error: 'Unauthorized',
          message: 'You must be authenticated to access this resource',
        })
      }

      return response.ok({
        user: {
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          createdAt: user.createdAt,
        },
      })
    } catch (error) {
      console.error('Auth me error:', error)
      return response.internalServerError({
        error: 'Failed to retrieve user data',
        message: error instanceof Error ? error.message : 'An unknown error occurred',
      })
    }
  }

  /**
   * Logout user (revoke current token)
   * POST /auth/logout
   */
  async logout({ auth, response }: HttpContext) {
    try {
      const user = auth.user

      if (!user) {
        return response.unauthorized({
          error: 'Unauthorized',
          message: 'You must be authenticated to logout',
        })
      }

      // Get the current access token from the auth context
      const token = auth.user?.currentAccessToken

      if (token) {
        await User.accessTokens.delete(user, token.identifier)
      }

      return response.ok({
        message: 'Logged out successfully',
      })
    } catch (error) {
      console.error('Logout error:', error)
      return response.internalServerError({
        error: 'Logout failed',
        message: error instanceof Error ? error.message : 'An unknown error occurred',
      })
    }
  }
}
