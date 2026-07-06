CREATE TABLE "organizations"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "slug" VARCHAR(255) NULL,
    "license_number" VARCHAR(255) NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
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
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "sites" ADD PRIMARY KEY("id");
CREATE TABLE "users"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "site_id" INTEGER NULL,
    "invited_by_id" INTEGER NULL,
    "name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "hashed_password" VARCHAR(255) NULL,
    "hashed_pin" VARCHAR(255) NULL,
    "role" VARCHAR(255) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
CREATE TABLE "patients"(
    "id" SERIAL NOT NULL,
    "full_name" VARCHAR(255) NOT NULL,
    "date_of_birth" DATE NULL,
    "age" INTEGER NULL,
    "gender" VARCHAR(255) NULL,
    "phone" VARCHAR(255) NULL,
    "national_id" VARCHAR(255) NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "gsrn" BIGINT NOT NULL
);
ALTER TABLE
    "patients" ADD PRIMARY KEY("id");
CREATE TABLE "lab_tests"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "price" DECIMAL(8, 2) NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT TRUE,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "field_definitions" jsonb NOT NULL,
    "category" TEXT NOT NULL
);
ALTER TABLE
    "lab_tests" ADD PRIMARY KEY("id");
CREATE TABLE "lab_orders"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "site_id" INTEGER NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "prescriber_name" VARCHAR(255) NULL,
    "ordered_by_id" INTEGER NULL,
    "urgency" VARCHAR(255) NULL,
    "payment_type" VARCHAR(255) NULL,
    "has_paid" BOOLEAN NOT NULL,
    "total_amount" DECIMAL(8, 2) NULL,
    "status" VARCHAR(255) NOT NULL DEFAULT 'pending',
    "lab_report" TEXT NULL,
    "test_findings" TEXT NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "patient_visit_id" BIGINT NOT NULL,
    "lab_request" TEXT NOT NULL,
    "referring_facility" TEXT NOT NULL,
    "referring_doctor" TEXT NOT NULL,
    "referred_date" TIME(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "lab_orders" ADD PRIMARY KEY("id");
CREATE TABLE "lab_order_results"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "lab_order_id" INTEGER NOT NULL,
    "lab_order_test_id" INTEGER NOT NULL,
    "template_id" INTEGER NULL,
    "results" jsonb NOT NULL DEFAULT 'ARRAY[]',
    "status" VARCHAR(255) NOT NULL DEFAULT 'pending',
    "sample_collected_on" DATE NULL,
    "test_performed_on" DATE NULL,
    "performed_by_id" INTEGER NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "lab_test_id" BIGINT NOT NULL,
    "sample_collection_description" BIGINT NOT NULL
);
ALTER TABLE
    "lab_order_results" ADD PRIMARY KEY("id");
CREATE TABLE "lab_consumable_usage"(
    "id" SERIAL NOT NULL,
    "organization_id" INTEGER NOT NULL,
    "lab_order_id" INTEGER NULL,
    "batch_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "used_by_id" INTEGER NULL,
    "purpose" VARCHAR(255) NULL,
    "used_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "inserted_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "lab_consumable_usage" ADD PRIMARY KEY("id");
CREATE TABLE "patient_visits"(
    "id" BIGINT NOT NULL,
    "patient_id" BIGINT NOT NULL,
    "site_id" BIGINT NOT NULL
);
ALTER TABLE
    "patient_visits" ADD PRIMARY KEY("id");
ALTER TABLE
    "lab_tests" ADD CONSTRAINT "lab_tests_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "lab_consumable_usage" ADD CONSTRAINT "lab_consumable_usage_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "lab_orders" ADD CONSTRAINT "lab_orders_patient_visit_id_foreign" FOREIGN KEY("patient_visit_id") REFERENCES "patient_visits"("id");
ALTER TABLE
    "patient_visits" ADD CONSTRAINT "patient_visits_patient_id_foreign" FOREIGN KEY("patient_id") REFERENCES "patients"("id");
ALTER TABLE
    "lab_orders" ADD CONSTRAINT "lab_orders_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "sites" ADD CONSTRAINT "sites_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "sites"("id");
ALTER TABLE
    "lab_order_results" ADD CONSTRAINT "lab_order_results_organization_id_foreign" FOREIGN KEY("organization_id") REFERENCES "organizations"("id");
ALTER TABLE
    "users" ADD CONSTRAINT "users_invited_by_id_foreign" FOREIGN KEY("invited_by_id") REFERENCES "users"("id");
ALTER TABLE
    "lab_orders" ADD CONSTRAINT "lab_orders_ordered_by_id_foreign" FOREIGN KEY("ordered_by_id") REFERENCES "users"("id");
ALTER TABLE
    "lab_order_results" ADD CONSTRAINT "lab_order_results_lab_order_id_foreign" FOREIGN KEY("lab_order_id") REFERENCES "lab_orders"("id");
ALTER TABLE
    "lab_order_results" ADD CONSTRAINT "lab_order_results_performed_by_id_foreign" FOREIGN KEY("performed_by_id") REFERENCES "users"("id");
ALTER TABLE
    "lab_orders" ADD CONSTRAINT "lab_orders_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "sites"("id");
ALTER TABLE
    "lab_consumable_usage" ADD CONSTRAINT "lab_consumable_usage_used_by_id_foreign" FOREIGN KEY("used_by_id") REFERENCES "users"("id");
ALTER TABLE
    "patient_visits" ADD CONSTRAINT "patient_visits_site_id_foreign" FOREIGN KEY("site_id") REFERENCES "sites"("id");
ALTER TABLE
    "lab_consumable_usage" ADD CONSTRAINT "lab_consumable_usage_lab_order_id_foreign" FOREIGN KEY("lab_order_id") REFERENCES "lab_orders"("id");
ALTER TABLE
    "lab_orders" ADD CONSTRAINT "lab_orders_patient_id_foreign" FOREIGN KEY("patient_id") REFERENCES "patients"("id");