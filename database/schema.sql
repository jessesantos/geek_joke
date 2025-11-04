-- ============================================================================
-- CRISTALINO DATABASE SCHEMA - PostgreSQL 18
-- Professional Reference Verification Platform
-- Complete Restructuring Based on Business Model
-- ============================================================================

-- ============================================================================
-- SECTION 1: EXTENSIONS
-- ============================================================================

-- UUID v7 support for time-ordered unique identifiers
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Full-text search and fuzzy matching capabilities
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- PostGIS for geolocation features (optional, for future expansion)
-- CREATE EXTENSION IF NOT EXISTS "postgis";

-- ============================================================================
-- SECTION 2: CUSTOM TYPES (ENUMS)
-- ============================================================================

-- Company member permissions and roles
CREATE TYPE company_member_role AS ENUM (
    'recruiter',       -- HR professional/recruiter
    'admin',           -- System administrator
    'viewer'           -- Read-only access
);

-- Company member permissions (organizational hierarchy)
CREATE TYPE company_member_permission AS ENUM (
    'owner',           -- Company owner (full access)
    'admin',           -- Administrator (manage users and processes)
    'recruiter',       -- Can create and manage reference processes
    'viewer'           -- Read-only access
);

-- Subscription plan types
CREATE TYPE plan_type AS ENUM (
    'free',            -- Free tier with limitations
    'starter',         -- Basic paid plan
    'professional',    -- Advanced features
    'enterprise'       -- Full features with custom limits
);

-- Payment transaction status
CREATE TYPE payment_status AS ENUM (
    'pending',         -- Payment initiated but not confirmed
    'processing',      -- Payment being processed
    'paid',            -- Successfully paid
    'failed',          -- Payment failed
    'refunded',        -- Payment refunded
    'cancelled'        -- Payment cancelled
);

-- Reference process lifecycle status
CREATE TYPE process_status AS ENUM (
    'draft',           -- Process created but not started
    'active',          -- Invitations sent, collecting responses
    'completed',       -- All references collected
    'cancelled',       -- Process cancelled by recruiter
    'expired'          -- Process expired (time-based)
);

-- Reference invitation status
CREATE TYPE invitation_status AS ENUM (
    'pending',         -- Invitation sent, awaiting response
    'opened',          -- Email/SMS opened by reference
    'in_progress',     -- Reference started filling form
    'completed',       -- Reference completed form
    'declined',        -- Reference declined to provide feedback
    'expired'          -- Invitation expired
);

-- Question types for reference forms
CREATE TYPE question_type AS ENUM (
    'rating_scale',    -- 1-5 or 1-10 scale
    'yes_no',          -- Boolean question
    'single_choice',   -- Multiple choice (one answer)
    'multiple_choice', -- Multiple choice (multiple answers)
    'text_short',      -- Short text response (1-2 lines)
    'text_long',       -- Long text response (paragraph)
    'competency_rating' -- Specific competency assessment
);

-- User account status
CREATE TYPE user_account_status AS ENUM (
    'pending_verification', -- Email not verified
    'active',              -- Account active
    'suspended',           -- Temporarily suspended
    'deactivated',         -- User deactivated account
    'banned'               -- Permanently banned
);

-- Employment relationship type
CREATE TYPE employment_type AS ENUM (
    'full_time',
    'part_time',
    'contract',
    'internship',
    'freelance',
    'volunteer'
);

-- ============================================================================
-- SECTION 3: UTILITY FUNCTIONS
-- ============================================================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to generate UUID v7 (time-ordered UUIDs)
-- Note: This is a placeholder. In production, use a proper UUID v7 implementation
-- or wait for PostgreSQL native support
CREATE OR REPLACE FUNCTION uuidv7() RETURNS UUID AS $$
DECLARE
    unix_ts_ms BIGINT;
    uuid_bytes BYTEA;
BEGIN
    unix_ts_ms = (EXTRACT(EPOCH FROM CLOCK_TIMESTAMP()) * 1000)::BIGINT;
    uuid_bytes = SUBSTRING(int8send(unix_ts_ms) FROM 3 FOR 6) ||
                 gen_random_bytes(10);
    uuid_bytes = SET_BYTE(uuid_bytes, 6, (GET_BYTE(uuid_bytes, 6) & 15) | 112);
    uuid_bytes = SET_BYTE(uuid_bytes, 8, (GET_BYTE(uuid_bytes, 8) & 63) | 128);
    RETURN encode(uuid_bytes, 'hex')::UUID;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- ============================================================================
-- SECTION 4: CORE TABLES (Level 0 - No Dependencies)
-- ============================================================================

-- Subscription plans available in the platform
CREATE TABLE plans (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(100) NOT NULL UNIQUE,
    plan_type plan_type NOT NULL,
    price_monthly DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    price_yearly DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    description TEXT,
    features JSONB NOT NULL DEFAULT '{}', -- Store plan features as JSON
    limits JSONB NOT NULL DEFAULT '{}', -- Store plan limits (e.g., max_processes_per_month, max_references_per_process)
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE plans IS 'Subscription plan catalog with pricing and feature limits';
COMMENT ON COLUMN plans.features IS 'JSON object with plan features: {custom_forms: true, analytics: true, api_access: false}';
COMMENT ON COLUMN plans.limits IS 'JSON object with plan limits: {max_processes_per_month: 10, max_references_per_process: 5}';

-- Core user accounts table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    password_hash TEXT NOT NULL, -- Bcrypt hash
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20),
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    profile_picture_url TEXT,
    timezone VARCHAR(50) DEFAULT 'UTC',
    language_code VARCHAR(10) DEFAULT 'en',
    account_status user_account_status NOT NULL DEFAULT 'pending_verification',
    last_login_at TIMESTAMPTZ,
    last_login_ip INET,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

COMMENT ON TABLE users IS 'Core user accounts for all platform users - roles are context-based, not fixed';
COMMENT ON COLUMN users.password_hash IS 'Bcrypt hashed password (use bcrypt with minimum cost factor 12)';
COMMENT ON COLUMN users.account_status IS 'Account status for authentication purposes only';

-- Companies (organizations that hire and use the platform)
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    legal_name VARCHAR(300) NOT NULL,
    trading_name VARCHAR(300),
    tax_id VARCHAR(50) UNIQUE, -- CNPJ for Brazil, EIN for US, etc.
    industry VARCHAR(200),
    company_size VARCHAR(50), -- 1-10, 11-50, 51-200, 201-500, 500+
    website_url VARCHAR(300),
    email_domain VARCHAR(255), -- Verified corporate email domain
    logo_url TEXT,
    description TEXT,
    
    -- Address information
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    country_code CHAR(2), -- ISO 3166-1 alpha-2
    
    -- Subscription information
    plan_id UUID NOT NULL,
    subscription_status VARCHAR(50) DEFAULT 'trial', -- trial, active, past_due, cancelled
    trial_ends_at TIMESTAMPTZ,
    subscription_starts_at TIMESTAMPTZ,
    subscription_ends_at TIMESTAMPTZ,
    
    -- Stripe integration
    stripe_customer_id VARCHAR(255) UNIQUE,
    stripe_subscription_id VARCHAR(255),
    
    -- Metadata
    settings JSONB DEFAULT '{}', -- Company-specific settings
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    
    CONSTRAINT fk_company_plan FOREIGN KEY (plan_id)
        REFERENCES plans(id) ON DELETE RESTRICT
);

COMMENT ON TABLE companies IS 'Organizations that subscribe to the platform to manage reference verification';
COMMENT ON COLUMN companies.tax_id IS 'Tax identification number (CNPJ, EIN, VAT number, etc.)';
COMMENT ON COLUMN companies.email_domain IS 'Verified corporate email domain for authentication purposes';
COMMENT ON COLUMN companies.stripe_customer_id IS 'Stripe customer ID for payment processing';

-- Form templates for reference verification
CREATE TABLE form_templates (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    company_id UUID, -- NULL for system default templates
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_default BOOLEAN NOT NULL DEFAULT FALSE, -- System default template
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    settings JSONB DEFAULT '{}', -- Template settings (e.g., time limit, reminders)
    created_by UUID, -- User who created the template
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_form_template_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_form_template_creator FOREIGN KEY (created_by)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE form_templates IS 'Reusable form templates for reference verification questionnaires';
COMMENT ON COLUMN form_templates.is_default IS 'System-provided default templates (company_id is NULL)';

-- Competencies catalog (skills/abilities to assess)
CREATE TABLE competencies (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(100), -- Technical, Soft Skills, Leadership, etc.
    is_system_default BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE competencies IS 'Catalog of professional competencies that can be assessed in references';

-- Free email domains blacklist (to enforce corporate email verification)
CREATE TABLE free_email_domains (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    domain VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE free_email_domains IS 'List of free email domains (gmail.com, yahoo.com) to enforce corporate email usage';

-- ============================================================================
-- SECTION 5: RELATIONSHIP TABLES (Level 1 - Single Dependency)
-- ============================================================================

-- User authentication sessions (JWT refresh tokens)
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL,
    refresh_token_hash TEXT NOT NULL UNIQUE, -- Hashed refresh token
    device_name VARCHAR(255),
    user_agent TEXT,
    ip_address INET,
    last_used_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_session_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

COMMENT ON TABLE user_sessions IS 'JWT refresh token sessions for user authentication';
COMMENT ON COLUMN user_sessions.refresh_token_hash IS 'SHA-256 hash of the refresh token';

-- Email verification tokens
CREATE TABLE email_verification_tokens (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_email_verification_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL,
    token_hash TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_password_reset_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

-- Company team members (users belonging to companies with roles)
CREATE TABLE company_members (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    company_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role company_member_role NOT NULL DEFAULT 'recruiter',
    permission company_member_permission NOT NULL DEFAULT 'viewer',
    job_title VARCHAR(200),
    department VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    invited_by UUID, -- User who invited this member
    invited_at TIMESTAMPTZ,
    joined_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT company_members_unique UNIQUE (company_id, user_id),
    CONSTRAINT fk_company_member_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_company_member_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_company_member_inviter FOREIGN KEY (invited_by)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE company_members IS 'Pivot table linking users to companies with specific roles and permissions';
COMMENT ON COLUMN company_members.role IS 'User role within this specific company context (recruiter, admin, viewer)';
COMMENT ON COLUMN company_members.permission IS 'User permission level within the company (owner, admin, recruiter, viewer)';

-- Payment transactions history
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    company_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'USD',
    status payment_status NOT NULL DEFAULT 'pending',
    payment_method VARCHAR(50), -- card, bank_transfer, etc.
    
    -- Stripe integration
    stripe_payment_intent_id VARCHAR(255) UNIQUE,
    stripe_invoice_id VARCHAR(255),
    stripe_charge_id VARCHAR(255),
    
    -- Invoice information
    invoice_number VARCHAR(100) UNIQUE,
    invoice_url TEXT,
    
    -- Metadata
    description TEXT,
    metadata JSONB DEFAULT '{}',
    failure_reason TEXT,
    refund_reason TEXT,
    
    -- Timestamps
    paid_at TIMESTAMPTZ,
    failed_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_payment_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE RESTRICT
);

COMMENT ON TABLE payments IS 'Payment transaction history with Stripe integration';
COMMENT ON COLUMN payments.stripe_payment_intent_id IS 'Stripe PaymentIntent ID for tracking';

-- Job positions posted by companies
CREATE TABLE job_positions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    company_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    department VARCHAR(100),
    employment_type employment_type,
    location VARCHAR(255),
    is_remote BOOLEAN DEFAULT FALSE,
    salary_range_min DECIMAL(12, 2),
    salary_range_max DECIMAL(12, 2),
    salary_currency CHAR(3) DEFAULT 'USD',
    requirements TEXT,
    responsibilities TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    posted_by UUID, -- Company member who posted
    posted_at TIMESTAMPTZ,
    closed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    
    CONSTRAINT fk_job_position_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_job_position_poster FOREIGN KEY (posted_by)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE job_positions IS 'Job openings for which reference verifications are conducted';

-- Employment history (candidate work experience)
CREATE TABLE employment_history (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL, -- Candidate
    company_name VARCHAR(300) NOT NULL,
    job_title VARCHAR(200) NOT NULL,
    employment_type employment_type,
    department VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE, -- NULL if currently employed
    is_current BOOLEAN NOT NULL DEFAULT FALSE,
    description TEXT,
    location VARCHAR(255),
    
    -- Reference information
    supervisor_name VARCHAR(200),
    supervisor_email VARCHAR(255),
    supervisor_phone VARCHAR(20),
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_employment_history_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT check_employment_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

COMMENT ON TABLE employment_history IS 'Candidate work experience and employment history';
COMMENT ON COLUMN employment_history.is_current IS 'TRUE if this is the current employer';

-- Questions within form templates
CREATE TABLE form_questions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    form_template_id UUID NOT NULL,
    question_text TEXT NOT NULL,
    question_type question_type NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    display_order INTEGER NOT NULL DEFAULT 0,
    
    -- Question configuration
    options JSONB, -- For choice questions: ["Option 1", "Option 2"]
    min_value INTEGER, -- For rating scales
    max_value INTEGER, -- For rating scales
    min_length INTEGER, -- For text questions
    max_length INTEGER, -- For text questions
    
    -- Competency assessment
    competency_id UUID, -- If this is a competency rating question
    
    -- Metadata
    help_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_form_question_template FOREIGN KEY (form_template_id)
        REFERENCES form_templates(id) ON DELETE CASCADE,
    CONSTRAINT fk_form_question_competency FOREIGN KEY (competency_id)
        REFERENCES competencies(id) ON DELETE SET NULL
);

COMMENT ON TABLE form_questions IS 'Individual questions within reference verification form templates';
COMMENT ON COLUMN form_questions.options IS 'JSON array of options for choice-type questions';

-- ============================================================================
-- SECTION 6: CORE BUSINESS LOGIC TABLES (Level 2 - Multiple Dependencies)
-- ============================================================================

-- Reference verification processes (the main business entity)
CREATE TABLE reference_processes (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    company_id UUID NOT NULL, -- Company requesting references
    candidate_user_id UUID NOT NULL, -- Candidate being verified
    job_position_id UUID, -- Optional: link to specific job opening
    form_template_id UUID NOT NULL, -- Form used for verification
    
    -- Process information
    title VARCHAR(255) NOT NULL, -- e.g., "Reference Check for John Doe - Software Engineer"
    description TEXT,
    status process_status NOT NULL DEFAULT 'draft',
    
    -- Process configuration
    number_of_references_required INTEGER NOT NULL DEFAULT 3,
    deadline_date DATE,
    send_reminders BOOLEAN NOT NULL DEFAULT TRUE,
    reminder_frequency_days INTEGER DEFAULT 3,
    
    -- Tracking
    created_by UUID NOT NULL, -- Recruiter who created the process
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    cancelled_at TIMESTAMPTZ,
    cancellation_reason TEXT,
    
    -- Metadata
    notes TEXT, -- Internal notes for recruiters
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    
    CONSTRAINT fk_reference_process_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE CASCADE,
    CONSTRAINT fk_reference_process_candidate FOREIGN KEY (candidate_user_id)
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_reference_process_job FOREIGN KEY (job_position_id)
        REFERENCES job_positions(id) ON DELETE SET NULL,
    CONSTRAINT fk_reference_process_template FOREIGN KEY (form_template_id)
        REFERENCES form_templates(id) ON DELETE RESTRICT,
    CONSTRAINT fk_reference_process_creator FOREIGN KEY (created_by)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE reference_processes IS 'Main business entity: reference verification processes for candidates';
COMMENT ON COLUMN reference_processes.status IS 'Current lifecycle status of the reference process';

-- Individual reference invitations within a process
CREATE TABLE invited_references (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    reference_process_id UUID NOT NULL,
    
    -- Reference provider information
    reference_user_id UUID, -- NULL if reference doesn't have an account yet
    reference_email VARCHAR(255) NOT NULL, -- Email where invitation is sent
    reference_name VARCHAR(200),
    reference_job_title VARCHAR(200),
    reference_company_name VARCHAR(300),
    reference_phone VARCHAR(20),
    relationship_to_candidate VARCHAR(100), -- "Direct Manager", "Colleague", "HR Contact"
    
    -- Invitation tracking
    invitation_status invitation_status NOT NULL DEFAULT 'pending',
    invitation_token TEXT UNIQUE, -- Secure token for accessing the form
    invitation_sent_at TIMESTAMPTZ,
    invitation_opened_at TIMESTAMPTZ,
    invitation_opened_count INTEGER DEFAULT 0,
    
    -- Form completion
    form_started_at TIMESTAMPTZ,
    form_completed_at TIMESTAMPTZ,
    form_responses JSONB, -- Stores all responses: {question_id: answer}
    time_spent_seconds INTEGER, -- Time spent filling the form
    
    -- Reminders
    last_reminder_sent_at TIMESTAMPTZ,
    reminder_count INTEGER DEFAULT 0,
    
    -- Decline
    declined_at TIMESTAMPTZ,
    decline_reason TEXT,
    
    -- Metadata
    ip_address INET, -- IP address of the reference provider
    user_agent TEXT,
    notes TEXT, -- Internal notes about this reference
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_invited_reference_process FOREIGN KEY (reference_process_id)
        REFERENCES reference_processes(id) ON DELETE CASCADE,
    CONSTRAINT fk_invited_reference_user FOREIGN KEY (reference_user_id)
        REFERENCES users(id) ON DELETE SET NULL
);

COMMENT ON TABLE invited_references IS 'Individual reference providers invited to verify a candidate';
COMMENT ON COLUMN invited_references.reference_user_id IS 'NULL until the reference provider creates an account or is linked';
COMMENT ON COLUMN invited_references.invitation_token IS 'Secure unique token for accessing the reference form without login';
COMMENT ON COLUMN invited_references.form_responses IS 'JSON object storing all question responses: {question_id: answer_value}';

-- Detailed responses to form questions
CREATE TABLE reference_responses (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    invited_reference_id UUID NOT NULL,
    form_question_id UUID NOT NULL,
    
    -- Response data
    response_text TEXT, -- For text-based questions
    response_number DECIMAL(10, 2), -- For numeric ratings
    response_boolean BOOLEAN, -- For yes/no questions
    response_options JSONB, -- For multiple choice: ["option1", "option2"]
    
    -- Competency rating (if applicable)
    competency_score INTEGER, -- 1-5 rating
    competency_notes TEXT,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_response_reference FOREIGN KEY (invited_reference_id)
        REFERENCES invited_references(id) ON DELETE CASCADE,
    CONSTRAINT fk_response_question FOREIGN KEY (form_question_id)
        REFERENCES form_questions(id) ON DELETE RESTRICT,
    CONSTRAINT check_competency_score CHECK (competency_score IS NULL OR (competency_score >= 1 AND competency_score <= 5))
);

COMMENT ON TABLE reference_responses IS 'Individual answers to form questions by reference providers';

-- Candidate competency assessments (aggregated from references)
CREATE TABLE candidate_competencies (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    reference_process_id UUID NOT NULL,
    competency_id UUID NOT NULL,
    average_score DECIMAL(3, 2), -- Average rating across all references
    total_responses INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_candidate_comp_process FOREIGN KEY (reference_process_id)
        REFERENCES reference_processes(id) ON DELETE CASCADE,
    CONSTRAINT fk_candidate_comp_competency FOREIGN KEY (competency_id)
        REFERENCES competencies(id) ON DELETE CASCADE,
    CONSTRAINT candidate_competencies_unique UNIQUE (reference_process_id, competency_id)
);

COMMENT ON TABLE candidate_competencies IS 'Aggregated competency scores for candidates from all reference responses';

-- Activity log for audit trail
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID,
    company_id UUID,
    entity_type VARCHAR(100) NOT NULL, -- 'reference_process', 'invited_reference', 'payment', etc.
    entity_id UUID NOT NULL,
    action VARCHAR(100) NOT NULL, -- 'created', 'updated', 'deleted', 'sent_invitation', etc.
    changes JSONB, -- Store what changed
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_activity_log_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_activity_log_company FOREIGN KEY (company_id)
        REFERENCES companies(id) ON DELETE SET NULL
);

COMMENT ON TABLE activity_logs IS 'Audit trail of all significant actions in the system';

-- Notifications for users
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    user_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL, -- 'invitation', 'reminder', 'process_completed', etc.
    entity_type VARCHAR(100), -- Related entity type
    entity_id UUID, -- Related entity ID
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

COMMENT ON TABLE notifications IS 'In-app notifications for users';

-- ============================================================================
-- SECTION 7: INDEXES FOR PERFORMANCE
-- ============================================================================

-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_account_status ON users(account_status) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_email_verified ON users(email_verified) WHERE email_verified = FALSE;
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Companies table indexes
CREATE INDEX idx_companies_tax_id ON companies(tax_id);
CREATE INDEX idx_companies_plan_id ON companies(plan_id);
CREATE INDEX idx_companies_subscription_status ON companies(subscription_status);
CREATE INDEX idx_companies_stripe_customer ON companies(stripe_customer_id);
CREATE INDEX idx_companies_is_active ON companies(is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_companies_trial_ends ON companies(trial_ends_at) WHERE subscription_status = 'trial';

-- Company members table indexes
CREATE INDEX idx_company_members_company ON company_members(company_id) WHERE is_active = TRUE;
CREATE INDEX idx_company_members_user ON company_members(user_id) WHERE is_active = TRUE;
CREATE INDEX idx_company_members_role ON company_members(company_id, role) WHERE is_active = TRUE;
CREATE INDEX idx_company_members_permission ON company_members(company_id, permission);

-- User sessions table indexes
CREATE INDEX idx_user_sessions_user ON user_sessions(user_id) WHERE revoked_at IS NULL;
CREATE INDEX idx_user_sessions_token_hash ON user_sessions(refresh_token_hash);
CREATE INDEX idx_user_sessions_expires ON user_sessions(expires_at) WHERE revoked_at IS NULL;

-- Payments table indexes
CREATE INDEX idx_payments_company ON payments(company_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_stripe_payment_intent ON payments(stripe_payment_intent_id);
CREATE INDEX idx_payments_created_at ON payments(created_at DESC);
CREATE INDEX idx_payments_invoice_number ON payments(invoice_number);

-- Reference processes table indexes
CREATE INDEX idx_reference_processes_company ON reference_processes(company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reference_processes_candidate ON reference_processes(candidate_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_reference_processes_status ON reference_processes(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_reference_processes_created_by ON reference_processes(created_by);
CREATE INDEX idx_reference_processes_job_position ON reference_processes(job_position_id);
CREATE INDEX idx_reference_processes_deadline ON reference_processes(deadline_date) WHERE status = 'active';
CREATE INDEX idx_reference_processes_created_at ON reference_processes(created_at DESC);

-- Invited references table indexes
CREATE INDEX idx_invited_references_process ON invited_references(reference_process_id);
CREATE INDEX idx_invited_references_user ON invited_references(reference_user_id);
CREATE INDEX idx_invited_references_email ON invited_references(reference_email);
CREATE INDEX idx_invited_references_status ON invited_references(invitation_status);
CREATE INDEX idx_invited_references_token ON invited_references(invitation_token);
CREATE INDEX idx_invited_references_pending ON invited_references(reference_process_id) 
    WHERE invitation_status IN ('pending', 'opened', 'in_progress');

-- Form templates table indexes
CREATE INDEX idx_form_templates_company ON form_templates(company_id) WHERE is_active = TRUE;
CREATE INDEX idx_form_templates_default ON form_templates(is_default) WHERE is_default = TRUE;
CREATE INDEX idx_form_templates_created_by ON form_templates(created_by);

-- Form questions table indexes
CREATE INDEX idx_form_questions_template ON form_questions(form_template_id);
CREATE INDEX idx_form_questions_competency ON form_questions(competency_id);
CREATE INDEX idx_form_questions_order ON form_questions(form_template_id, display_order);

-- Reference responses table indexes
CREATE INDEX idx_reference_responses_invited_ref ON reference_responses(invited_reference_id);
CREATE INDEX idx_reference_responses_question ON reference_responses(form_question_id);

-- Job positions table indexes
CREATE INDEX idx_job_positions_company ON job_positions(company_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_job_positions_is_active ON job_positions(is_active) WHERE deleted_at IS NULL;
CREATE INDEX idx_job_positions_posted_by ON job_positions(posted_by);
CREATE INDEX idx_job_positions_title ON job_positions USING gin(to_tsvector('english', title));

-- Employment history table indexes
CREATE INDEX idx_employment_history_user ON employment_history(user_id);
CREATE INDEX idx_employment_history_current ON employment_history(user_id) WHERE is_current = TRUE;
CREATE INDEX idx_employment_history_dates ON employment_history(user_id, start_date DESC);

-- Activity logs table indexes
CREATE INDEX idx_activity_logs_user ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_company ON activity_logs(company_id);
CREATE INDEX idx_activity_logs_entity ON activity_logs(entity_type, entity_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at DESC);

-- Notifications table indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = FALSE;
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- Candidate competencies table indexes
CREATE INDEX idx_candidate_competencies_process ON candidate_competencies(reference_process_id);
CREATE INDEX idx_candidate_competencies_competency ON candidate_competencies(competency_id);

-- Email verification tokens indexes
CREATE INDEX idx_email_verification_user ON email_verification_tokens(user_id);
CREATE INDEX idx_email_verification_expires ON email_verification_tokens(expires_at) WHERE used_at IS NULL;

-- Password reset tokens indexes
CREATE INDEX idx_password_reset_user ON password_reset_tokens(user_id);
CREATE INDEX idx_password_reset_expires ON password_reset_tokens(expires_at) WHERE used_at IS NULL;

-- ============================================================================
-- SECTION 8: TRIGGERS
-- ============================================================================

-- Automatically update updated_at column on record updates
CREATE TRIGGER update_users_timestamp BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_companies_timestamp BEFORE UPDATE ON companies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_company_members_timestamp BEFORE UPDATE ON company_members
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_plans_timestamp BEFORE UPDATE ON plans
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_timestamp BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reference_processes_timestamp BEFORE UPDATE ON reference_processes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_invited_references_timestamp BEFORE UPDATE ON invited_references
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_job_positions_timestamp BEFORE UPDATE ON job_positions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employment_history_timestamp BEFORE UPDATE ON employment_history
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_templates_timestamp BEFORE UPDATE ON form_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_questions_timestamp BEFORE UPDATE ON form_questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reference_responses_timestamp BEFORE UPDATE ON reference_responses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_candidate_competencies_timestamp BEFORE UPDATE ON candidate_competencies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- SECTION 9: INITIAL DATA SEEDS
-- ============================================================================

-- Insert default plans
INSERT INTO plans (name, plan_type, price_monthly, price_yearly, description, features, limits) VALUES
(
    'Free',
    'free',
    0.00,
    0.00,
    'Basic plan for trying out Cristalino',
    '{"custom_forms": false, "analytics": false, "api_access": false, "priority_support": false}',
    '{"max_processes_per_month": 2, "max_references_per_process": 3, "max_team_members": 1}'
),
(
    'Starter',
    'starter',
    49.00,
    490.00,
    'Perfect for small teams and startups',
    '{"custom_forms": true, "analytics": true, "api_access": false, "priority_support": false}',
    '{"max_processes_per_month": 20, "max_references_per_process": 5, "max_team_members": 5}'
),
(
    'Professional',
    'professional',
    149.00,
    1490.00,
    'Advanced features for growing companies',
    '{"custom_forms": true, "analytics": true, "api_access": true, "priority_support": true, "custom_branding": true}',
    '{"max_processes_per_month": 100, "max_references_per_process": 10, "max_team_members": 20}'
),
(
    'Enterprise',
    'enterprise',
    499.00,
    4990.00,
    'Unlimited features for large organizations',
    '{"custom_forms": true, "analytics": true, "api_access": true, "priority_support": true, "custom_branding": true, "dedicated_support": true, "sso": true}',
    '{"max_processes_per_month": -1, "max_references_per_process": -1, "max_team_members": -1}'
);

-- Insert default competencies
INSERT INTO competencies (name, description, category) VALUES
('Communication', 'Ability to clearly convey information and ideas', 'Soft Skills'),
('Teamwork', 'Ability to work effectively with others', 'Soft Skills'),
('Problem Solving', 'Ability to analyze situations and find effective solutions', 'Technical'),
('Leadership', 'Ability to guide and motivate team members', 'Leadership'),
('Time Management', 'Ability to prioritize and manage time effectively', 'Soft Skills'),
('Adaptability', 'Ability to adjust to changing circumstances', 'Soft Skills'),
('Technical Proficiency', 'Competence in required technical skills', 'Technical'),
('Attention to Detail', 'Thoroughness and accuracy in work', 'Soft Skills'),
('Initiative', 'Self-motivation and proactiveness', 'Soft Skills'),
('Reliability', 'Consistency and dependability in delivering work', 'Soft Skills');

-- Insert common free email domains
INSERT INTO free_email_domains (domain) VALUES
('gmail.com'),
('yahoo.com'),
('hotmail.com'),
('outlook.com'),
('aol.com'),
('icloud.com'),
('mail.com'),
('protonmail.com'),
('zoho.com'),
('yandex.com');

-- ============================================================================
-- SECTION 10: VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View: Active reference processes with summary statistics
CREATE VIEW v_active_reference_processes AS
SELECT 
    rp.id,
    rp.title,
    rp.company_id,
    c.legal_name as company_name,
    rp.candidate_user_id,
    u.first_name || ' ' || u.last_name as candidate_name,
    u.email as candidate_email,
    rp.status,
    rp.number_of_references_required,
    COUNT(ir.id) as total_invitations_sent,
    COUNT(CASE WHEN ir.invitation_status = 'completed' THEN 1 END) as completed_references,
    COUNT(CASE WHEN ir.invitation_status = 'pending' THEN 1 END) as pending_references,
    rp.deadline_date,
    rp.created_at,
    rp.started_at
FROM reference_processes rp
JOIN companies c ON rp.company_id = c.id
JOIN users u ON rp.candidate_user_id = u.id
LEFT JOIN invited_references ir ON rp.id = ir.reference_process_id
WHERE rp.deleted_at IS NULL AND rp.status IN ('active', 'draft')
GROUP BY rp.id, c.legal_name, u.first_name, u.last_name, u.email;

COMMENT ON VIEW v_active_reference_processes IS 'Active reference processes with summary statistics';

-- View: Company subscription overview
CREATE VIEW v_company_subscriptions AS
SELECT 
    c.id as company_id,
    c.legal_name,
    c.email_domain,
    p.name as plan_name,
    p.plan_type,
    c.subscription_status,
    c.trial_ends_at,
    c.subscription_ends_at,
    COUNT(DISTINCT cm.user_id) as team_member_count,
    COUNT(DISTINCT rp.id) FILTER (WHERE rp.created_at >= DATE_TRUNC('month', CURRENT_DATE)) as processes_this_month,
    c.created_at as company_created_at
FROM companies c
JOIN plans p ON c.plan_id = p.id
LEFT JOIN company_members cm ON c.id = cm.company_id AND cm.is_active = TRUE
LEFT JOIN reference_processes rp ON c.id = rp.company_id AND rp.deleted_at IS NULL
WHERE c.deleted_at IS NULL
GROUP BY c.id, c.legal_name, c.email_domain, p.name, p.plan_type, c.subscription_status, 
         c.trial_ends_at, c.subscription_ends_at, c.created_at;

COMMENT ON VIEW v_company_subscriptions IS 'Overview of company subscriptions with usage statistics';

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================