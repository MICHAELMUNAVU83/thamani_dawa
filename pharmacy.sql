CREATE TABLE "organizations"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "slug" VARCHAR(255) NULL,
    "license_number" VARCHAR(255) NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "is_subscription_active" BOOLEAN NOT NULL,
    "kyc_details" jsonb NOT NULL
);
ALTER TABLE
    "organizations" ADD PRIMARY KEY("id");
CREATE TABLE "sites"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "site_type" VARCHAR(255) NOT NULL,
    "gln" VARCHAR(255) NULL,
    "address" VARCHAR(255) NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "long" BIGINT NOT NULL,
    "lat" BIGINT NOT NULL
);
ALTER TABLE
    "sites" ADD PRIMARY KEY("id");
CREATE TABLE "users"(
    "id" BIGINT NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "site_id" INTEGER NULL,
    "invited_by_id" INTEGER NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "hashed_password" VARCHAR(255) NULL,
    "role" VARCHAR(255) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
CREATE TABLE "products"(
    "id" SERIAL NOT NULL,
    "site_id" INTEGER NOT NULL,
    "generic_name" VARCHAR(255) NULL,
    "brand_name" VARCHAR(255) NULL,
    "category" VARCHAR(255) NULL,
    "uom" VARCHAR(255) NULL,
    "gtin" VARCHAR(255) NULL,
    "is_otc" BOOLEAN NOT NULL,
    "is_dangerous_drug" BOOLEAN NOT NULL,
    "reorder_level" INTEGER NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "price" INTEGER NOT NULL
);
ALTER TABLE
    "products" ADD PRIMARY KEY("id");
CREATE TABLE "suppliers"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "contact" VARCHAR(255) NULL,
    "phone" VARCHAR(255) NULL,
    "email" VARCHAR(255) NULL,
    "gln" VARCHAR(255) NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "suppliers" ADD PRIMARY KEY("id");
CREATE TABLE "batches"(
    "id" SERIAL NOT NULL,
    "product_id" INTEGER NOT NULL,
    "site_id" INTEGER NOT NULL,
    "gtin" VARCHAR(255) NOT NULL,
    "batch_no" VARCHAR(255) NOT NULL,
    "serial" VARCHAR(255) NULL,
    "manufacture_date" DATE NULL,
    "expiry_date" DATE NOT NULL,
    "quantity" INTEGER NOT NULL,
    "remaining_quantity" INTEGER NOT NULL,
    "cost_per_unit" DECIMAL(8, 2) NULL,
    "supplier_id" INTEGER NULL,
    "received_by_id" INTEGER NULL,
    "received_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "is_approved" BOOLEAN NOT NULL,
    "approver_id" BIGINT NOT NULL
);
ALTER TABLE
    "batches" ADD PRIMARY KEY("id");
CREATE TABLE "patients"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "full_name" VARCHAR(255) NOT NULL,
    "date_of_birth" DATE NULL,
    "age" INTEGER NULL,
    "gender" VARCHAR(255) NULL,
    "phone" VARCHAR(255) NULL,
    "national_id" VARCHAR(255) NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "patients" ADD PRIMARY KEY("id");
CREATE TABLE "prescriptions"(
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NULL,
    "payment_type" VARCHAR(255) NULL,
    "has_paid" BOOLEAN NOT NULL,
    "total_amount" DECIMAL(8, 2) NULL,
    "status" VARCHAR(255) NOT NULL DEFAULT 'pending',
    "notes" TEXT NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "patient_visit_id" BIGINT NOT NULL,
    "doctor's_note" TEXT NOT NULL,
    "is_external" BOOLEAN NOT NULL,
    "source_facility" TEXT NOT NULL,
    "referring_doctor" TEXT NOT NULL,
    "referral_date" TIME(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "prescriptions" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "prescriptions"."user_id" IS 'the user who entered it';
CREATE TABLE "prescription_items"(
    "id" SERIAL NOT NULL,
    "prescription_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "quantity_prescribed" INTEGER NOT NULL,
    "dosage_instructions" VARCHAR(255) NULL,
    "frequency" VARCHAR(255) NULL,
    "duration_in_days" INTEGER NULL,
    "route_of_administration" VARCHAR(255) NULL,
    "quantity_dispensed" INTEGER NOT NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "prescription_items" ADD PRIMARY KEY("id");
CREATE TABLE "patient_visits"(
    "id" BIGINT NOT NULL,
    "patient_id" BIGINT NOT NULL,
    "site_id" BIGINT NOT NULL,
    "user_id" BIGINT NOT NULL,
    "visit_type" TEXT NOT NULL
);
ALTER TABLE
    "patient_visits" ADD PRIMARY KEY("id");
COMMENT
ON COLUMN
    "patient_visits"."user_id" IS 'user who served em';
CREATE TABLE "batch_allocations"(
    "id" BIGINT NOT NULL,
    "prescription_item_id" BIGINT NOT NULL,
    "quantity" BIGINT NOT NULL,
    "batch_id" BIGINT NOT NULL,
    "status" TEXT NOT NULL
);
ALTER TABLE
    "batch_allocations" ADD PRIMARY KEY("id");
ALTER TABLE
    "sites" ADD CONSTRAINT "sites_id_foreign" FOREIGN KEY("id") REFERENCES "patient_visits"("site_id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "sites"("id");
ALTER TABLE
    "batches" ADD CONSTRAINT "batches_supplier_id_foreign" FOREIGN KEY("supplier_id") REFERENCES "suppliers"("id");
ALTER TABLE
    "prescriptions" ADD CONSTRAINT "prescriptions_patient_visit_id_foreign" FOREIGN KEY("patient_visit_id") REFERENCES "patient_visits"("id");
ALTER TABLE
    "sites" ADD CONSTRAINT "sites_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "products" ADD CONSTRAINT "products_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "organizations"("id");
ALTER TABLE
    "prescription_items" ADD CONSTRAINT "prescription_items_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("id");
ALTER TABLE
    "prescription_items" ADD CONSTRAINT "prescription_items_prescription_id_foreign" FOREIGN KEY("prescription_id") REFERENCES "prescriptions"("id");
ALTER TABLE
    "batch_allocations" ADD CONSTRAINT "batch_allocations_batch_id_foreign" FOREIGN KEY("batch_id") REFERENCES "batches"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_invited_by_id_foreign" FOREIGN KEY("invited_by_id") REFERENCES "users"("id");
ALTER TABLE
    "prescriptions" ADD CONSTRAINT "prescriptions_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "patient_visits" ADD CONSTRAINT "patient_visits_patient_id_foreign" FOREIGN KEY("patient_id") REFERENCES "patients"("id");
ALTER TABLE
    "batch_allocations" ADD CONSTRAINT "batch_allocations_prescription_item_id_foreign" FOREIGN KEY("prescription_item_id") REFERENCES "prescription_items"("id");
ALTER TABLE
    "batches" ADD CONSTRAINT "batches_received_by_id_foreign" FOREIGN KEY("received_by_id") REFERENCES "users"("id");
ALTER TABLE
    "suppliers" ADD CONSTRAINT "suppliers_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "batches" ADD CONSTRAINT "batches_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "sites"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "patients" ADD CONSTRAINT "patients_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "batches" ADD CONSTRAINT "batches_product_id_foreign" FOREIGN KEY("product_id") REFERENCES "products"("id");