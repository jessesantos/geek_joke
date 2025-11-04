import vine from '@vinejs/vine'

/**
 * Validator for login requests
 * Validates email and password fields
 */
export const loginValidator = vine.compile(
  vine.object({
    email: vine
      .string()
      .trim()
      .email()
      .normalizeEmail()
      .minLength(5)
      .maxLength(254),

    password: vine
      .string()
      .minLength(8)
      .maxLength(255),
  })
)
