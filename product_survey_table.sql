-- =====================================================
-- SNOWFLAKE SQL: Online Product Survey Table
-- Voice of Customer Data Structure
-- =====================================================

-- Create the main product survey table
CREATE OR REPLACE TABLE PRODUCT_SURVEY (
    -- Primary identifiers
    SURVEY_ID VARCHAR(50) PRIMARY KEY,
    CUSTOMER_ID VARCHAR(50) NOT NULL,
    PRODUCT_ID VARCHAR(50) NOT NULL,
    
    -- Survey metadata
    SURVEY_DATE TIMESTAMP_NTZ NOT NULL,
    SURVEY_CHANNEL VARCHAR(20) NOT NULL, -- 'web', 'mobile', 'email', 'sms'
    SURVEY_VERSION VARCHAR(10) NOT NULL,
    COMPLETION_STATUS VARCHAR(20) NOT NULL, -- 'completed', 'partial', 'abandoned'
    
    -- Customer demographics
    CUSTOMER_AGE_RANGE VARCHAR(20),
    CUSTOMER_GENDER VARCHAR(20),
    CUSTOMER_LOCATION VARCHAR(100),
    CUSTOMER_SEGMENT VARCHAR(30), -- 'new', 'returning', 'vip', 'at_risk'
    
    -- Product information
    PRODUCT_NAME VARCHAR(200) NOT NULL,
    PRODUCT_CATEGORY VARCHAR(100) NOT NULL,
    PRODUCT_SUBCATEGORY VARCHAR(100),
    PRODUCT_PRICE DECIMAL(10,2),
    PURCHASE_DATE DATE,
    
    -- Survey responses - Ratings (1-5 scale)
    OVERALL_SATISFACTION INTEGER CHECK (OVERALL_SATISFACTION BETWEEN 1 AND 5),
    PRODUCT_QUALITY_RATING INTEGER CHECK (PRODUCT_QUALITY_RATING BETWEEN 1 AND 5),
    VALUE_FOR_MONEY_RATING INTEGER CHECK (VALUE_FOR_MONEY_RATING BETWEEN 1 AND 5),
    DELIVERY_RATING INTEGER CHECK (DELIVERY_RATING BETWEEN 1 AND 5),
    CUSTOMER_SERVICE_RATING INTEGER CHECK (CUSTOMER_SERVICE_RATING BETWEEN 1 AND 5),
    EASE_OF_USE_RATING INTEGER CHECK (EASE_OF_USE_RATING BETWEEN 1 AND 5),
    
    -- Net Promoter Score (0-10 scale)
    NPS_SCORE INTEGER CHECK (NPS_SCORE BETWEEN 0 AND 10),
    
    -- Binary satisfaction indicators
    WOULD_RECOMMEND BOOLEAN,
    WOULD_PURCHASE_AGAIN BOOLEAN,
    MEETS_EXPECTATIONS BOOLEAN,
    
    -- Text feedback
    REVIEW_TEXT TEXT, -- Free format customer review
    POSITIVE_FEEDBACK TEXT,
    NEGATIVE_FEEDBACK TEXT,
    IMPROVEMENT_SUGGESTIONS TEXT,
    ADDITIONAL_COMMENTS TEXT,
    
    -- Survey engagement metrics
    TIME_TO_COMPLETE_SECONDS INTEGER,
    SURVEY_SOURCE VARCHAR(50), -- 'post_purchase', 'email_campaign', 'website_popup', 'app_notification'
    
    -- Technical metadata
    CREATED_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    UPDATED_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    DATA_SOURCE VARCHAR(50) DEFAULT 'survey_platform',
    
    -- Derived fields for analysis
    NPS_CATEGORY VARCHAR(20) AS (
        CASE 
            WHEN NPS_SCORE >= 9 THEN 'Promoter'
            WHEN NPS_SCORE >= 7 THEN 'Passive'
            ELSE 'Detractor'
        END
    ),
    
    SATISFACTION_CATEGORY VARCHAR(20) AS (
        CASE 
            WHEN OVERALL_SATISFACTION >= 4 THEN 'Satisfied'
            WHEN OVERALL_SATISFACTION = 3 THEN 'Neutral'
            ELSE 'Dissatisfied'
        END
    )
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS IDX_SURVEY_CUSTOMER_ID ON PRODUCT_SURVEY(CUSTOMER_ID);
CREATE INDEX IF NOT EXISTS IDX_SURVEY_PRODUCT_ID ON PRODUCT_SURVEY(PRODUCT_ID);
CREATE INDEX IF NOT EXISTS IDX_SURVEY_DATE ON PRODUCT_SURVEY(SURVEY_DATE);
CREATE INDEX IF NOT EXISTS IDX_SURVEY_CATEGORY ON PRODUCT_SURVEY(PRODUCT_CATEGORY);

-- =====================================================
-- SAMPLE DATA: 100 Product Survey Records
-- =====================================================

INSERT INTO PRODUCT_SURVEY (
    SURVEY_ID, CUSTOMER_ID, PRODUCT_ID, SURVEY_DATE, SURVEY_CHANNEL, SURVEY_VERSION,
    COMPLETION_STATUS, CUSTOMER_AGE_RANGE, CUSTOMER_GENDER, CUSTOMER_LOCATION, CUSTOMER_SEGMENT,
    PRODUCT_NAME, PRODUCT_CATEGORY, PRODUCT_SUBCATEGORY, PRODUCT_PRICE, PURCHASE_DATE,
    OVERALL_SATISFACTION, PRODUCT_QUALITY_RATING, VALUE_FOR_MONEY_RATING, DELIVERY_RATING,
    CUSTOMER_SERVICE_RATING, EASE_OF_USE_RATING, NPS_SCORE, WOULD_RECOMMEND, WOULD_PURCHASE_AGAIN,
    MEETS_EXPECTATIONS, REVIEW_TEXT, POSITIVE_FEEDBACK, NEGATIVE_FEEDBACK, IMPROVEMENT_SUGGESTIONS,
    ADDITIONAL_COMMENTS, TIME_TO_COMPLETE_SECONDS, SURVEY_SOURCE
) VALUES

-- Record 1
('SUR001', 'CUST001', 'PROD001', '2024-01-15 14:30:00', 'web', 'v2.1', 'completed', 
'25-34', 'Female', 'New York, NY', 'returning', 'Align High-Rise Pant 25"', 'Women''s Bottoms', 
'Leggings', 128.00, '2024-01-10', 5, 5, 4, 5, 4, 5, 9, TRUE, TRUE, TRUE,
'These leggings are amazing! So buttery soft and they don''t roll down during my workouts. Perfect for yoga and everyday wear.',
'Incredible fabric quality and fit', NULL, 'Maybe add more color options',
'Love these so much, already ordered 3 more pairs!', 180, 'post_purchase'),

-- Record 2
('SUR002', 'CUST002', 'PROD002', '2024-01-16 09:15:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Los Angeles, CA', 'new', 'ABC Classic-Fit 5 Pocket Pant 32"', 'Men''s Bottoms', 
'Pants', 138.00, '2024-01-12', 4, 4, 3, 4, 5, 4, 8, TRUE, TRUE, TRUE,
'Bought these for work and they''re great. Comfortable all day and look professional.',
'Great for office wear', 'A bit pricey but worth it', 'More color options would be nice',
'Overall satisfied with purchase', 240, 'email_campaign'),

-- Record 3
('SUR003', 'CUST003', 'PROD003', '2024-01-17 16:45:00', 'web', 'v2.1', 'completed',
'18-24', 'Female', 'Chicago, IL', 'vip', 'Swiftly Tech Short Sleeve 2.0', 'Women''s Tops', 
'Shirts', 68.00, '2024-01-14', 5, 5, 5, 5, 4, 5, 10, TRUE, TRUE, TRUE,
'Perfect for running! Doesn''t get smelly even after long workouts. Fits perfectly.',
'Amazing moisture-wicking technology', NULL, NULL,
'Perfect fit and quality!', 120, 'website_popup'),

-- Record 4
('SUR004', 'CUST004', 'PROD004', '2024-01-18 11:20:00', 'email', 'v2.1', 'completed',
'45-54', 'Male', 'Houston, TX', 'returning', 'Metal Vent Tech Short Sleeve', 'Men''s Tops', 
'Shirts', 78.00, '2024-01-15', 3, 3, 4, 3, 3, 2, 6, FALSE, FALSE, FALSE,
'It''s okay but not worth the price. Fabric feels thin for what you pay.',
'Decent for workouts', 'Overpriced for the quality', 'Better value for money needed',
'Not what I expected from Lululemon', 300, 'post_purchase'),

-- Record 5
('SUR005', 'CUST005', 'PROD005', '2024-01-19 13:10:00', 'mobile', 'v2.1', 'partial',
'25-34', 'Female', 'Phoenix, AZ', 'new', 'Reversible Mat 5mm', 'Accessories', 
'Yoga Equipment', 88.00, '2024-01-16', 4, 4, 4, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good grip and the reversible feature is nice. A bit heavy to carry around though.',
'Great for hot yoga', 'Heavier than expected', 'Maybe a lighter version',
NULL, 90, 'app_notification'),

-- Record 6
('SUR006', 'CUST006', 'PROD006', '2024-01-20 10:30:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Philadelphia, PA', 'at_risk', 'City Excursion Hoodie', 'Men''s Outerwear', 
'Hoodies', 148.00, '2024-01-17', 2, 2, 3, 2, 2, 3, 4, FALSE, FALSE, FALSE,
'Fits okay but the quality isn''t what I expected for the price. Fabric feels cheap.',
NULL, 'Material feels cheap and overpriced', 'Use better quality materials',
'Disappointed with Lululemon quality', 420, 'email_campaign'),

-- Record 7
('SUR007', 'CUST007', 'PROD007', '2024-01-21 15:45:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'San Antonio, TX', 'returning', 'Everywhere Belt Bag', 'Accessories', 
'Bags', 38.00, '2024-01-18', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Love this bag! Perfect size for my phone, keys, and cards. Great for running errands.',
'Perfect size and very convenient', NULL, 'More color options would be great',
'Will definitely buy more colors', 150, 'post_purchase'),

-- Record 8
('SUR008', 'CUST008', 'PROD008', '2024-01-22 08:25:00', 'web', 'v2.1', 'completed',
'18-24', 'Male', 'San Diego, CA', 'new', 'Pace Breaker Short 7"', 'Men''s Bottoms', 
'Shorts', 68.00, '2024-01-19', 4, 4, 4, 4, 4, 5, 8, TRUE, TRUE, TRUE,
'Great for workouts and running. The liner is comfortable and they don''t ride up.',
'Great for running and gym', 'Could use better pockets', 'Deeper pockets would be nice',
'Good value for athletic shorts', 200, 'website_popup'),

-- Record 9
('SUR009', 'CUST009', 'PROD009', '2024-01-23 12:15:00', 'email', 'v2.1', 'completed',
'45-54', 'Female', 'Dallas, TX', 'vip', 'Scuba Oversized Full-Zip Hoodie', 'Women''s Outerwear', 
'Hoodies', 118.00, '2024-01-20', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'This hoodie is everything! So cozy and the oversized fit is perfect. I live in this.',
'Incredibly soft and comfortable', NULL, NULL,
'Exceeded expectations completely', 180, 'post_purchase'),

-- Record 10
('SUR010', 'CUST010', 'PROD010', '2024-01-24 14:50:00', 'mobile', 'v2.1', 'abandoned',
'25-34', 'Male', 'San Jose, CA', 'returning', 'Commission Short Sleeve Shirt', 'Men''s Tops', 
'Shirts', 128.00, '2024-01-21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, NULL, 30, 'app_notification'),

-- Record 11
('SUR011', 'CUST011', 'PROD011', '2024-01-25 09:40:00', 'web', 'v2.1', 'completed',
'35-44', 'Female', 'Austin, TX', 'new', 'Wunder Train High-Rise Tight 25"', 'Women''s Bottoms', 
'Leggings', 98.00, '2024-01-22', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'These are great for training! They stay put and the fabric is supportive.',
'Great for high-intensity workouts', 'Sizing runs a bit small', 'Size chart could be clearer',
'Solid leggings overall', 210, 'email_campaign'),

-- Record 12
('SUR012', 'CUST012', 'PROD012', '2024-01-26 16:20:00', 'mobile', 'v2.1', 'completed',
'18-24', 'Male', 'Jacksonville, FL', 'returning', 'City Adventurer Backpack 17L', 'Accessories', 
'Bags', 148.00, '2024-01-23', 5, 5, 4, 5, 4, 5, 9, TRUE, TRUE, TRUE,
'Perfect size for daily use and travel. Well-made and lots of compartments.',
'Excellent organization and quality', NULL, 'More color options would be nice',
'Great for work and travel!', 165, 'post_purchase'),

-- Record 13
('SUR013', 'CUST013', 'PROD013', '2024-01-27 11:35:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Fort Worth, TX', 'at_risk', 'Soft Ambitions Crop Crew', 'Women''s Tops', 
'Sweatshirts', 98.00, '2024-01-24', 3, 3, 4, 3, 3, 4, 6, FALSE, TRUE, TRUE,
'It''s soft but I expected more for the price. Fits a bit boxy.',
'Comfortable fabric', 'Fit is not flattering', 'Better tailoring needed',
'Functional but not perfect', 280, 'website_popup'),

-- Record 14
('SUR014', 'CUST014', 'PROD014', '2024-01-28 13:25:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Columbus, OH', 'vip', 'License to Train Short 7"', 'Men''s Bottoms', 
'Shorts', 78.00, '2024-01-25', 4, 4, 4, 4, 5, 4, 8, TRUE, TRUE, TRUE,
'Great for lifting and training. The fabric is stretchy and comfortable.',
'Perfect for gym workouts', 'Could use deeper pockets', 'Better pocket design',
'Very convenient for training', 190, 'post_purchase'),

-- Record 15
('SUR015', 'CUST015', 'PROD015', '2024-01-29 10:15:00', 'mobile', 'v2.1', 'partial',
'45-54', 'Female', 'Charlotte, NC', 'new', 'The Towel', 'Accessories', 
'Yoga Equipment', 38.00, '2024-01-26', 4, 4, 4, 4, 4, NULL, 7, TRUE, TRUE, TRUE,
'Good for hot yoga but wish it was a bit bigger. Absorbs sweat well.',
'Great absorption for hot yoga', NULL, 'Larger size option needed',
NULL, 75, 'app_notification'),

-- Record 16
('SUR016', 'CUST016', 'PROD016', '2024-01-30 15:10:00', 'web', 'v2.1', 'completed',
'35-44', 'Male', 'San Francisco, CA', 'returning', 'Bluetooth Speaker', 'Electronics', 
'Audio', 129.99, '2024-01-27', 5, 5, 5, 5, 4, 5, 10, TRUE, TRUE, TRUE,
'Incredible sound quality for the price', NULL, NULL,
'Best speaker I have owned', 140, 'email_campaign'),

-- Record 17
('SUR017', 'CUST017', 'PROD017', '2024-01-31 12:45:00', 'mobile', 'v2.1', 'completed',
'18-24', 'Female', 'Indianapolis, IN', 'new', 'Face Mask Set', 'Beauty & Personal Care', 
'Skincare', 19.99, '2024-01-28', 4, 4, 5, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Great value and effective results', 'Packaging could be better', 'Improve packaging design',
'Will buy again', 160, 'post_purchase'),

-- Record 18
('SUR018', 'CUST018', 'PROD018', '2024-02-01 09:30:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Seattle, WA', 'at_risk', 'Electric Kettle', 'Home & Kitchen', 
'Small Appliances', 49.99, '2024-01-29', 2, 2, 3, 2, 2, 2, 3, FALSE, FALSE, FALSE,
NULL, 'Stopped working after one week', 'Better quality control needed',
'Very disappointed', 350, 'website_popup'),

-- Record 19
('SUR019', 'CUST019', 'PROD019', '2024-02-02 14:20:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Denver, CO', 'vip', 'Silk Pillowcase', 'Home & Kitchen', 
'Bedding', 39.99, '2024-01-30', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Luxurious feel and great for hair', NULL, 'More color options please',
'Love sleeping on silk', 175, 'post_purchase'),

-- Record 20
('SUR020', 'CUST020', 'PROD020', '2024-02-03 11:55:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Washington, DC', 'returning', 'Resistance Bands Set', 'Sports & Outdoors', 
'Fitness Equipment', 29.99, '2024-01-31', 4, 4, 5, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Great workout variety and portable', 'Instructions could be clearer', 'Better exercise guide',
'Good value for home workouts', 220, 'app_notification'),

-- Record 21
('SUR021', 'CUST021', 'PROD021', '2024-02-04 16:40:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Boston, MA', 'new', 'Ceramic Mug Set', 'Home & Kitchen', 
'Drinkware', 34.99, '2024-02-01', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Beautiful design and perfect size', 'One mug arrived with small chip', 'Better packaging protection',
'Overall very happy', 185, 'email_campaign'),

-- Record 22
('SUR022', 'CUST022', 'PROD022', '2024-02-05 08:15:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Male', 'El Paso, TX', 'returning', 'Phone Case', 'Electronics', 
'Phone Accessories', 19.99, '2024-02-02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 25, 'post_purchase'),

-- Record 23
('SUR023', 'CUST023', 'PROD023', '2024-02-06 13:50:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Detroit, MI', 'at_risk', 'Hand Cream', 'Beauty & Personal Care', 
'Hand Care', 14.99, '2024-02-03', 3, 3, 4, 3, 3, 4, 6, FALSE, TRUE, TRUE,
'Moisturizes well', 'Scent is too strong', 'Offer unscented version',
'Does the job but scent is overwhelming', 250, 'website_popup'),

-- Record 24
('SUR024', 'CUST024', 'PROD024', '2024-02-07 10:25:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Memphis, TN', 'vip', 'Mechanical Keyboard', 'Electronics', 
'Computer Accessories', 159.99, '2024-02-04', 5, 5, 4, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Amazing typing experience and build quality', NULL, NULL,
'Worth every penny', 195, 'post_purchase'),

-- Record 25
('SUR025', 'CUST025', 'PROD025', '2024-02-08 15:35:00', 'mobile', 'v2.1', 'partial',
'35-44', 'Female', 'Portland, OR', 'new', 'Candle Set', 'Home & Kitchen', 
'Home Fragrance', 49.99, '2024-02-05', 4, 4, 4, 4, 4, NULL, 8, TRUE, TRUE, TRUE,
'Beautiful scents and long lasting', NULL, 'More seasonal scents',
NULL, 60, 'app_notification'),

-- Record 26
('SUR026', 'CUST026', 'PROD026', '2024-02-09 12:10:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Oklahoma City, OK', 'returning', 'Tool Organizer', 'Home & Garden', 
'Storage & Organization', 39.99, '2024-02-06', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Great for organizing my workshop', 'Could use more compartments', 'Add more dividers',
'Solid construction', 230, 'email_campaign'),

-- Record 27
('SUR027', 'CUST027', 'PROD027', '2024-02-10 09:45:00', 'mobile', 'v2.1', 'completed',
'18-24', 'Female', 'Las Vegas, NV', 'new', 'Lip Balm Set', 'Beauty & Personal Care', 
'Lip Care', 12.99, '2024-02-07', 5, 5, 5, 5, 4, 5, 9, TRUE, TRUE, TRUE,
'Love all the flavors and very moisturizing', NULL, NULL,
'Perfect for daily use', 110, 'post_purchase'),

-- Record 28
('SUR028', 'CUST028', 'PROD028', '2024-02-11 14:30:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Louisville, KY', 'at_risk', 'Bird Feeder', 'Home & Garden', 
'Outdoor Decor', 29.99, '2024-02-08', 2, 2, 3, 2, 2, 3, 4, FALSE, FALSE, FALSE,
NULL, 'Squirrels can easily access it', 'Make it more squirrel-proof',
'Not effective against squirrels', 310, 'website_popup'),

-- Record 29
('SUR029', 'CUST029', 'PROD029', '2024-02-12 11:20:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Baltimore, MD', 'vip', 'Yoga Block Set', 'Sports & Outdoors', 
'Yoga Equipment', 24.99, '2024-02-09', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Perfect density and size for my practice', NULL, NULL,
'Essential for my yoga routine', 155, 'post_purchase'),

-- Record 30
('SUR030', 'CUST030', 'PROD030', '2024-02-13 16:15:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Milwaukee, WI', 'returning', 'Car Phone Mount', 'Electronics', 
'Car Accessories', 19.99, '2024-02-10', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Sturdy and easy to adjust', 'Suction cup could be stronger', 'Improve suction mechanism',
'Good for navigation', 170, 'app_notification'),

-- Record 31
('SUR031', 'CUST031', 'PROD031', '2024-02-14 13:40:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Albuquerque, NM', 'new', 'Tea Variety Pack', 'Food & Beverages', 
'Tea & Coffee', 27.99, '2024-02-11', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Great variety of flavors to try', 'Some teas were too mild', 'Stronger flavor options',
'Nice introduction to different teas', 200, 'email_campaign'),

-- Record 32
('SUR032', 'CUST032', 'PROD032', '2024-02-15 10:55:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Tucson, AZ', 'returning', 'Gaming Headset', 'Electronics', 
'Gaming Accessories', 79.99, '2024-02-12', 4, 4, 3, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good sound quality for gaming', 'Microphone quality could be better', 'Improve microphone',
NULL, 85, 'post_purchase'),

-- Record 33
('SUR033', 'CUST033', 'PROD033', '2024-02-16 15:25:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Fresno, CA', 'at_risk', 'Garden Gloves', 'Home & Garden', 
'Gardening Supplies', 16.99, '2024-02-13', 3, 3, 4, 3, 3, 3, 5, FALSE, TRUE, TRUE,
'Decent protection for gardening', 'Sizing runs small', 'Better size chart needed',
'Functional but tight fit', 270, 'website_popup'),

-- Record 34
('SUR034', 'CUST034', 'PROD034', '2024-02-17 12:30:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Sacramento, CA', 'vip', 'Protein Shaker Bottle', 'Sports & Outdoors', 
'Fitness Accessories', 14.99, '2024-02-14', 5, 5, 5, 5, 4, 5, 9, TRUE, TRUE, TRUE,
'No clumps and easy to clean', NULL, 'More color options',
'Perfect for post-workout', 125, 'post_purchase'),

-- Record 35
('SUR035', 'CUST035', 'PROD035', '2024-02-18 09:10:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Kansas City, MO', 'new', 'Scented Lotion', 'Beauty & Personal Care', 
'Body Care', 22.99, '2024-02-15', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Lovely scent and moisturizing', 'Bottle design could be better', 'Improve pump mechanism',
'Pleasant daily moisturizer', 180, 'app_notification'),

-- Record 36
('SUR036', 'CUST036', 'PROD036', '2024-02-19 14:45:00', 'web', 'v2.1', 'abandoned',
'45-54', 'Male', 'Mesa, AZ', 'returning', 'Drill Bit Set', 'Tools & Home Improvement', 
'Power Tool Accessories', 34.99, '2024-02-16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 40, 'email_campaign'),

-- Record 37
('SUR037', 'CUST037', 'PROD037', '2024-02-20 11:35:00', 'mobile', 'v2.1', 'completed',
'18-24', 'Female', 'Virginia Beach, VA', 'new', 'Hair Scrunchies Set', 'Beauty & Personal Care', 
'Hair Accessories', 9.99, '2024-02-17', 5, 5, 5, 5, 4, 5, 10, TRUE, TRUE, TRUE,
'Cute colors and gentle on hair', NULL, NULL,
'Perfect for everyday use', 95, 'post_purchase'),

-- Record 38
('SUR038', 'CUST038', 'PROD038', '2024-02-21 16:20:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Atlanta, GA', 'at_risk', 'Reading Light', 'Home & Kitchen', 
'Lighting', 24.99, '2024-02-18', 2, 2, 3, 2, 2, 2, 3, FALSE, FALSE, FALSE,
NULL, 'Too dim and flimsy construction', 'Brighter LED and better build',
'Not suitable for reading', 320, 'website_popup'),

-- Record 39
('SUR039', 'CUST039', 'PROD039', '2024-02-22 13:15:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Colorado Springs, CO', 'vip', 'Aromatherapy Diffuser', 'Home & Kitchen', 
'Home Fragrance', 59.99, '2024-02-19', 5, 5, 4, 5, 5, 4, 9, TRUE, TRUE, TRUE,
'Creates perfect ambiance and easy to use', NULL, 'Include more essential oil samples',
'Love using this every evening', 165, 'post_purchase'),

-- Record 40
('SUR040', 'CUST040', 'PROD040', '2024-02-23 10:50:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Omaha, NE', 'returning', 'Insulated Water Bottle', 'Sports & Outdoors', 
'Hydration', 34.99, '2024-02-20', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Keeps drinks cold all day', 'Cap is a bit difficult to open', 'Easier opening mechanism',
'Great for workouts', 190, 'app_notification'),

-- Record 41
('SUR041', 'CUST041', 'PROD041', '2024-02-24 15:30:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Raleigh, NC', 'new', 'Kitchen Scale', 'Home & Kitchen', 
'Kitchen Tools', 29.99, '2024-02-21', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Accurate measurements and sleek design', 'Display could be larger', 'Bigger display screen',
'Helpful for baking', 210, 'email_campaign'),

-- Record 42
('SUR042', 'CUST042', 'PROD042', '2024-02-25 12:25:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Long Beach, CA', 'returning', 'Skateboard Wheels', 'Sports & Outdoors', 
'Skateboarding', 39.99, '2024-02-22', 4, 4, 4, 4, NULL, 4, 8, TRUE, TRUE, TRUE,
'Smooth ride and good durability', NULL, 'More hardness options',
NULL, 70, 'post_purchase'),

-- Record 43
('SUR043', 'CUST043', 'PROD043', '2024-02-26 09:40:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Miami, FL', 'at_risk', 'Pill Organizer', 'Health & Personal Care', 
'Medical Supplies', 19.99, '2024-02-23', 3, 3, 4, 3, 3, 3, 6, FALSE, TRUE, TRUE,
'Functional for daily pills', 'Compartments are too small', 'Larger compartment size',
'Works but could be better designed', 260, 'website_popup'),

-- Record 44
('SUR044', 'CUST044', 'PROD044', '2024-02-27 14:55:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Oakland, CA', 'vip', 'Laptop Stand', 'Electronics', 
'Computer Accessories', 49.99, '2024-02-24', 5, 5, 4, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Perfect height and very stable', NULL, NULL,
'Improved my posture significantly', 175, 'post_purchase'),

-- Record 45
('SUR045', 'CUST045', 'PROD045', '2024-02-28 11:10:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Minneapolis, MN', 'new', 'Bath Bombs Set', 'Beauty & Personal Care', 
'Bath & Body', 24.99, '2024-02-25', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Relaxing scents and fizzes well', 'Colors stained the tub slightly', 'Non-staining formula',
'Great for relaxation', 155, 'app_notification'),

-- Record 46
('SUR046', 'CUST046', 'PROD046', '2024-03-01 16:35:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Tulsa, OK', 'returning', 'Car Air Freshener', 'Automotive', 
'Interior Accessories', 7.99, '2024-02-26', 3, 3, 4, 3, 3, 4, 6, FALSE, TRUE, TRUE,
'Decent scent but fades quickly', 'Doesn not last long enough', 'Longer lasting formula',
'Okay for the price', 240, 'email_campaign'),

-- Record 47
('SUR047', 'CUST047', 'PROD047', '2024-03-02 13:20:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Wichita, KS', 'new', 'Phone Screen Protector', 'Electronics', 
'Phone Accessories', 12.99, '2024-02-27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 20, 'post_purchase'),

-- Record 48
('SUR048', 'CUST048', 'PROD048', '2024-03-03 10:45:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'New Orleans, LA', 'at_risk', 'Magnifying Glass', 'Health & Personal Care', 
'Vision Aids', 18.99, '2024-02-28', 2, 2, 3, 2, 2, 2, 4, FALSE, FALSE, FALSE,
NULL, 'Magnification is not strong enough', 'Higher magnification power',
'Does not meet my needs', 290, 'website_popup'),

-- Record 49
('SUR049', 'CUST049', 'PROD049', '2024-03-04 15:15:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Cleveland, OH', 'vip', 'Jewelry Organizer', 'Home & Kitchen', 
'Storage & Organization', 44.99, '2024-03-01', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Perfect size and beautiful design', NULL, NULL,
'Keeps all my jewelry organized', 185, 'post_purchase'),

-- Record 50
('SUR050', 'CUST050', 'PROD050', '2024-03-05 12:30:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Tampa, FL', 'returning', 'Fishing Lure Set', 'Sports & Outdoors', 
'Fishing', 29.99, '2024-03-02', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Good variety and effective lures', 'Storage box could be better', 'Improve tackle box',
'Caught several fish already', 200, 'app_notification'),

-- Record 51
('SUR051', 'CUST051', 'PROD051', '2024-03-06 09:25:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Honolulu, HI', 'new', 'Sunscreen SPF 50', 'Beauty & Personal Care', 
'Sun Protection', 16.99, '2024-03-03', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Good protection and not greasy', 'Scent is a bit strong', 'Unscented option',
'Works well for beach days', 170, 'email_campaign'),

-- Record 52
('SUR052', 'CUST052', 'PROD052', '2024-03-07 14:40:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Anaheim, CA', 'returning', 'Gaming Chair', 'Furniture', 
'Office Furniture', 199.99, '2024-03-04', 4, 4, 3, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Comfortable for long gaming sessions', 'Assembly was challenging', 'Better assembly instructions',
NULL, 90, 'post_purchase'),

-- Record 53
('SUR053', 'CUST053', 'PROD053', '2024-03-08 11:55:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'St. Louis, MO', 'at_risk', 'Compression Socks', 'Health & Personal Care', 
'Medical Supplies', 22.99, '2024-03-05', 3, 3, 4, 3, 3, 3, 5, FALSE, TRUE, TRUE,
'Provides some relief', 'Too tight around the calf', 'Better sizing options',
'Functional but uncomfortable', 250, 'website_popup'),

-- Record 54
('SUR054', 'CUST054', 'PROD054', '2024-03-09 16:10:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Riverside, CA', 'vip', 'Bluetooth Earbuds', 'Electronics', 
'Audio', 89.99, '2024-03-06', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Excellent sound quality and battery life', NULL, 'Wireless charging case',
'Best earbuds for the price', 160, 'post_purchase'),

-- Record 55
('SUR055', 'CUST055', 'PROD055', '2024-03-10 13:35:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Corpus Christi, TX', 'new', 'Makeup Brushes Set', 'Beauty & Personal Care', 
'Makeup Tools', 34.99, '2024-03-07', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Soft bristles and good variety', 'Could use a better storage case', 'Include travel case',
'Great for daily makeup', 180, 'app_notification'),

-- Record 56
('SUR056', 'CUST056', 'PROD056', '2024-03-11 10:20:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Lexington, KY', 'returning', 'Grill Brush', 'Home & Garden', 
'Grilling Accessories', 19.99, '2024-03-08', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Cleans grill grates effectively', 'Handle could be longer', 'Extend handle length',
'Good for regular grill maintenance', 220, 'email_campaign'),

-- Record 57
('SUR057', 'CUST057', 'PROD057', '2024-03-12 15:45:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Stockton, CA', 'new', 'Nail Polish Set', 'Beauty & Personal Care', 
'Nail Care', 19.99, '2024-03-09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 35, 'post_purchase'),

-- Record 58
('SUR058', 'CUST058', 'PROD058', '2024-03-13 12:15:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Pittsburgh, PA', 'at_risk', 'Flashlight', 'Tools & Home Improvement', 
'Lighting', 24.99, '2024-03-10', 2, 2, 3, 2, 2, 3, 4, FALSE, FALSE, FALSE,
NULL, 'Not bright enough and feels cheap', 'Brighter LED and better construction',
'Disappointed with quality', 300, 'website_popup'),

-- Record 59
('SUR059', 'CUST059', 'PROD059', '2024-03-14 09:30:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Anchorage, AK', 'vip', 'Winter Gloves', 'Clothing', 
'Accessories', 39.99, '2024-03-11', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Very warm and comfortable fit', NULL, 'Touch screen compatible fingertips',
'Perfect for Alaska winters', 145, 'post_purchase'),

-- Record 60
('SUR060', 'CUST060', 'PROD060', '2024-03-15 14:25:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Cincinnati, OH', 'returning', 'Bike Lock', 'Sports & Outdoors', 
'Cycling', 34.99, '2024-03-12', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Sturdy and easy to use', 'Key mechanism could be smoother', 'Improve lock mechanism',
'Good security for my bike', 195, 'app_notification'),

-- Record 61
('SUR061', 'CUST061', 'PROD061', '2024-03-16 11:40:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Greensboro, NC', 'new', 'Plant Food', 'Home & Garden', 
'Plant Care', 12.99, '2024-03-13', 4, 4, 5, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Plants are thriving since using this', 'Instructions could be clearer', 'Better usage instructions',
'Great value for plant health', 165, 'email_campaign'),

-- Record 62
('SUR062', 'CUST062', 'PROD062', '2024-03-17 16:55:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Newark, NJ', 'returning', 'Protein Bar Pack', 'Food & Beverages', 
'Nutrition Bars', 24.99, '2024-03-14', 4, 4, 4, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good taste and protein content', NULL, 'More flavor varieties',
NULL, 80, 'post_purchase'),

-- Record 63
('SUR063', 'CUST063', 'PROD063', '2024-03-18 13:10:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Plano, TX', 'at_risk', 'Reading Pillow', 'Home & Kitchen', 
'Bedding', 49.99, '2024-03-15', 3, 3, 3, 3, 3, 3, 6, FALSE, TRUE, TRUE,
'Provides some back support', 'Not as firm as expected', 'Firmer support option',
'Okay but not great', 280, 'website_popup'),

-- Record 64
('SUR064', 'CUST064', 'PROD064', '2024-03-19 10:35:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Lincoln, NE', 'vip', 'Portable Charger', 'Electronics', 
'Phone Accessories', 39.99, '2024-03-16', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Fast charging and compact design', NULL, NULL,
'Essential for travel', 150, 'post_purchase'),

-- Record 65
('SUR065', 'CUST065', 'PROD065', '2024-03-20 15:20:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Orlando, FL', 'new', 'Hair Serum', 'Beauty & Personal Care', 
'Hair Care', 28.99, '2024-03-17', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Makes hair smooth and shiny', 'Bottle is small for the price', 'Larger size option',
'Good results but pricey', 175, 'app_notification'),

-- Record 66
('SUR066', 'CUST066', 'PROD066', '2024-03-21 12:45:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Chula Vista, CA', 'returning', 'Socket Wrench Set', 'Tools & Home Improvement', 
'Hand Tools', 59.99, '2024-03-18', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Good quality and complete set', 'Case could be more organized', 'Better case organization',
'Useful for home repairs', 210, 'email_campaign'),

-- Record 67
('SUR067', 'CUST067', 'PROD067', '2024-03-22 09:15:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Chandler, AZ', 'new', 'Face Wash', 'Beauty & Personal Care', 
'Facial Cleansers', 16.99, '2024-03-19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 30, 'post_purchase'),

-- Record 68
('SUR068', 'CUST068', 'PROD068', '2024-03-23 14:50:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Laredo, TX', 'at_risk', 'Shoe Insoles', 'Health & Personal Care', 
'Foot Care', 19.99, '2024-03-20', 2, 2, 3, 2, 2, 2, 3, FALSE, FALSE, FALSE,
NULL, 'No noticeable comfort improvement', 'Better cushioning material',
'Waste of money', 310, 'website_popup'),

-- Record 69
('SUR069', 'CUST069', 'PROD069', '2024-03-24 11:25:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Durham, NC', 'vip', 'Scarf Collection', 'Clothing', 
'Accessories', 49.99, '2024-03-21', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Beautiful patterns and soft material', NULL, 'More seasonal colors',
'Love the variety and quality', 155, 'post_purchase'),

-- Record 70
('SUR070', 'CUST070', 'PROD070', '2024-03-25 16:40:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Lubbock, TX', 'returning', 'Camping Lantern', 'Sports & Outdoors', 
'Camping & Hiking', 44.99, '2024-03-22', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Bright light and good battery life', 'Could be more compact', 'Smaller form factor',
'Great for camping trips', 185, 'app_notification'),

-- Record 71
('SUR071', 'CUST071', 'PROD071', '2024-03-26 13:15:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Garland, TX', 'new', 'Spice Rack', 'Home & Kitchen', 
'Storage & Organization', 34.99, '2024-03-23', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Great for organizing spices', 'Could use more jars', 'Include more spice jars',
'Helps keep kitchen organized', 200, 'email_campaign'),

-- Record 72
('SUR072', 'CUST072', 'PROD072', '2024-03-27 10:30:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Scottsdale, AZ', 'returning', 'Sunglasses', 'Clothing', 
'Accessories', 59.99, '2024-03-24', 4, 4, 3, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good UV protection and style', 'Case could be sturdier', 'Better protective case',
NULL, 75, 'post_purchase'),

-- Record 73
('SUR073', 'CUST073', 'PROD073', '2024-03-28 15:55:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Norfolk, VA', 'at_risk', 'Heating Pad', 'Health & Personal Care', 
'Pain Relief', 39.99, '2024-03-25', 3, 3, 3, 3, 3, 3, 5, FALSE, TRUE, TRUE,
'Provides some warmth', 'Temperature control is inconsistent', 'Better temperature regulation',
'Functional but not reliable', 270, 'website_popup'),

-- Record 74
('SUR074', 'CUST074', 'PROD074', '2024-03-29 12:20:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Madison, WI', 'vip', 'Desk Organizer', 'Office Products', 
'Desk Accessories', 29.99, '2024-03-26', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Perfect size and great compartments', NULL, NULL,
'Keeps my desk perfectly organized', 140, 'post_purchase'),

-- Record 75
('SUR075', 'CUST075', 'PROD075', '2024-03-30 09:45:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Winston-Salem, NC', 'new', 'Hand Sanitizer Pack', 'Health & Personal Care', 
'Personal Hygiene', 14.99, '2024-03-27', 4, 4, 5, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Good value and effective', 'Scent is too strong', 'Unscented option available',
'Convenient for travel', 160, 'app_notification'),

-- Record 76
('SUR076', 'CUST076', 'PROD076', '2024-03-31 14:10:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Fayetteville, NC', 'returning', 'Car Vacuum', 'Automotive', 
'Cleaning Supplies', 49.99, '2024-03-28', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Good suction power for car cleaning', 'Cord could be longer', 'Extend power cord',
'Helpful for car maintenance', 225, 'email_campaign'),

-- Record 77
('SUR077', 'CUST077', 'PROD077', '2024-04-01 11:35:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Irving, TX', 'new', 'Lip Gloss Set', 'Beauty & Personal Care', 
'Lip Care', 22.99, '2024-03-29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 25, 'post_purchase'),

-- Record 78
('SUR078', 'CUST078', 'PROD078', '2024-04-02 16:25:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Chesapeake, VA', 'at_risk', 'Garden Hose', 'Home & Garden', 
'Watering Equipment', 39.99, '2024-03-30', 2, 2, 3, 2, 2, 3, 4, FALSE, FALSE, FALSE,
NULL, 'Kinks easily and poor water pressure', 'Better hose material',
'Does not meet expectations', 290, 'website_popup'),

-- Record 79
('SUR079', 'CUST079', 'PROD079', '2024-04-03 13:40:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Gilbert, AZ', 'vip', 'Moisturizing Cream', 'Beauty & Personal Care', 
'Skincare', 44.99, '2024-03-31', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Amazing results and luxurious feel', NULL, 'Larger size option',
'Best moisturizer I have used', 170, 'post_purchase'),

-- Record 80
('SUR080', 'CUST080', 'PROD080', '2024-04-04 10:15:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Baton Rouge, LA', 'returning', 'Tire Pressure Gauge', 'Automotive', 
'Maintenance Tools', 16.99, '2024-04-01', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Accurate readings and easy to use', 'Could use a protective case', 'Include storage case',
'Essential car tool', 180, 'app_notification'),

-- Record 81
('SUR081', 'CUST081', 'PROD081', '2024-04-05 15:50:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Hialeah, FL', 'new', 'Cutting Board Set', 'Home & Kitchen', 
'Kitchen Tools', 39.99, '2024-04-02', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Good variety of sizes', 'Could be thicker', 'Increase board thickness',
'Useful for meal prep', 195, 'email_campaign'),

-- Record 82
('SUR082', 'CUST082', 'PROD082', '2024-04-06 12:25:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Spokane, WA', 'returning', 'Energy Drink Pack', 'Food & Beverages', 
'Energy Drinks', 19.99, '2024-04-03', 4, 4, 4, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good energy boost and taste', NULL, 'Sugar-free options',
NULL, 65, 'post_purchase'),

-- Record 83
('SUR083', 'CUST083', 'PROD083', '2024-04-07 09:10:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Tacoma, WA', 'at_risk', 'Joint Support Supplement', 'Health & Wellness', 
'Supplements', 49.99, '2024-04-04', 3, 3, 3, 3, 3, 3, 5, FALSE, TRUE, TRUE,
'Some improvement in joint comfort', 'Takes too long to see results', 'Faster acting formula',
'Slow but some improvement', 260, 'website_popup'),

-- Record 84
('SUR084', 'CUST084', 'PROD084', '2024-04-08 14:35:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Fremont, CA', 'vip', 'Monitor Stand', 'Electronics', 
'Computer Accessories', 54.99, '2024-04-05', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Perfect height adjustment and sturdy', NULL, 'Built-in USB hub',
'Improved my workspace significantly', 165, 'post_purchase'),

-- Record 85
('SUR085', 'CUST085', 'PROD085', '2024-04-09 11:20:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Richmond, VA', 'new', 'Nail File Set', 'Beauty & Personal Care', 
'Nail Care', 11.99, '2024-04-06', 4, 4, 5, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Great variety and good quality', 'Could use a storage case', 'Include carrying case',
'Perfect for manicures', 145, 'app_notification'),

-- Record 86
('SUR086', 'CUST086', 'PROD086', '2024-04-10 16:45:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Mobile, AL', 'returning', 'Lawn Sprinkler', 'Home & Garden', 
'Watering Equipment', 29.99, '2024-04-07', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Good coverage and easy to adjust', 'Plastic feels a bit flimsy', 'More durable materials',
'Does the job well', 205, 'email_campaign'),

-- Record 87
('SUR087', 'CUST087', 'PROD087', '2024-04-11 13:15:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Des Moines, IA', 'new', 'Hair Clips Set', 'Beauty & Personal Care', 
'Hair Accessories', 8.99, '2024-04-08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 15, 'post_purchase'),

-- Record 88
('SUR088', 'CUST088', 'PROD088', '2024-04-12 10:40:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Grand Rapids, MI', 'at_risk', 'Blood Pressure Monitor', 'Health & Personal Care', 
'Medical Devices', 79.99, '2024-04-09', 2, 2, 2, 2, 2, 2, 3, FALSE, FALSE, FALSE,
NULL, 'Inconsistent readings and confusing interface', 'Better accuracy and simpler design',
'Not reliable for health monitoring', 320, 'website_popup'),

-- Record 89
('SUR089', 'CUST089', 'PROD089', '2024-04-13 15:30:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Akron, OH', 'vip', 'Perfume Sample Set', 'Beauty & Personal Care', 
'Fragrance', 34.99, '2024-04-10', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Love trying different scents', NULL, NULL,
'Perfect way to discover new fragrances', 155, 'post_purchase'),

-- Record 90
('SUR090', 'CUST090', 'PROD090', '2024-04-14 12:55:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Little Rock, AR', 'returning', 'Multitool', 'Tools & Home Improvement', 
'Multi-Tools', 39.99, '2024-04-11', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Compact and has all essential tools', 'Could use a belt clip', 'Add belt attachment',
'Handy for everyday carry', 190, 'app_notification'),

-- Record 91
('SUR091', 'CUST091', 'PROD091', '2024-04-15 09:20:00', 'web', 'v2.1', 'completed',
'45-54', 'Female', 'Huntsville, AL', 'new', 'Throw Pillow Set', 'Home & Kitchen', 
'Home Decor', 49.99, '2024-04-12', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Beautiful colors and comfortable', 'Covers could be softer', 'Softer fabric option',
'Great addition to living room', 175, 'email_campaign'),

-- Record 92
('SUR092', 'CUST092', 'PROD092', '2024-04-16 14:45:00', 'mobile', 'v2.1', 'partial',
'18-24', 'Male', 'Glendale, AZ', 'returning', 'Protein Powder', 'Health & Wellness', 
'Supplements', 44.99, '2024-04-13', 4, 4, 4, 4, NULL, 4, 7, TRUE, TRUE, TRUE,
'Good taste and mixes well', NULL, 'More flavor options',
NULL, 85, 'post_purchase'),

-- Record 93
('SUR093', 'CUST093', 'PROD093', '2024-04-17 11:10:00', 'web', 'v2.1', 'completed',
'55-64', 'Female', 'Grand Prairie, TX', 'at_risk', 'Reading Glasses Case', 'Health & Personal Care', 
'Vision Care', 12.99, '2024-04-14', 3, 3, 4, 3, 3, 3, 6, FALSE, TRUE, TRUE,
'Protects glasses adequately', 'Hinge feels weak', 'Stronger hinge mechanism',
'Functional but not durable', 240, 'website_popup'),

-- Record 94
('SUR094', 'CUST094', 'PROD094', '2024-04-18 16:35:00', 'email', 'v2.1', 'completed',
'25-34', 'Male', 'Brownsville, TX', 'vip', 'Wireless Mouse', 'Electronics', 
'Computer Accessories', 34.99, '2024-04-15', 5, 5, 4, 5, 5, 5, 9, TRUE, TRUE, TRUE,
'Smooth tracking and comfortable grip', NULL, 'RGB lighting option',
'Perfect for work and gaming', 150, 'post_purchase'),

-- Record 95
('SUR095', 'CUST095', 'PROD095', '2024-04-19 13:25:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Female', 'Newport News, VA', 'new', 'Body Lotion', 'Beauty & Personal Care', 
'Body Care', 18.99, '2024-04-16', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Moisturizes well and pleasant scent', 'Bottle pump could be better', 'Improve pump mechanism',
'Good daily moisturizer', 165, 'app_notification'),

-- Record 96
('SUR096', 'CUST096', 'PROD096', '2024-04-20 10:50:00', 'web', 'v2.1', 'completed',
'45-54', 'Male', 'Santa Clarita, CA', 'returning', 'Tape Measure', 'Tools & Home Improvement', 
'Measuring Tools', 14.99, '2024-04-17', 4, 4, 4, 4, 4, 4, 7, TRUE, TRUE, TRUE,
'Accurate measurements and sturdy', 'Clip could be stronger', 'Reinforce belt clip',
'Essential tool for projects', 185, 'email_campaign'),

-- Record 97
('SUR097', 'CUST097', 'PROD097', '2024-04-21 15:15:00', 'mobile', 'v2.1', 'abandoned',
'18-24', 'Female', 'Providence, RI', 'new', 'Eye Shadow Palette', 'Beauty & Personal Care', 
'Makeup', 29.99, '2024-04-18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
NULL, NULL, NULL, NULL, 20, 'post_purchase'),

-- Record 98
('SUR098', 'CUST098', 'PROD098', '2024-04-22 12:40:00', 'web', 'v2.1', 'completed',
'55-64', 'Male', 'Peoria, AZ', 'at_risk', 'Vitamin D Supplement', 'Health & Wellness', 
'Supplements', 24.99, '2024-04-19', 3, 3, 3, 3, 3, 3, 5, FALSE, TRUE, TRUE,
'Easy to swallow', 'No noticeable health improvement', 'Higher potency option',
'Uncertain about effectiveness', 270, 'website_popup'),

-- Record 99
('SUR099', 'CUST099', 'PROD099', '2024-04-23 09:30:00', 'email', 'v2.1', 'completed',
'25-34', 'Female', 'Elk Grove, CA', 'vip', 'Jewelry Box', 'Home & Kitchen', 
'Storage & Organization', 69.99, '2024-04-20', 5, 5, 5, 5, 5, 5, 10, TRUE, TRUE, TRUE,
'Beautiful craftsmanship and perfect size', NULL, NULL,
'Exceeded all expectations', 160, 'post_purchase'),

-- Record 100
('SUR100', 'CUST100', 'PROD100', '2024-04-24 14:20:00', 'mobile', 'v2.1', 'completed',
'35-44', 'Male', 'Salem, OR', 'returning', 'Camping Cookware Set', 'Sports & Outdoors', 
'Camping & Hiking', 89.99, '2024-04-21', 4, 4, 4, 4, 4, 4, 8, TRUE, TRUE, TRUE,
'Lightweight and durable for camping', 'Could use better storage bag', 'Improve carrying case',
'Great for outdoor cooking', 200, 'app_notification');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check total record count
SELECT COUNT(*) as total_records FROM PRODUCT_SURVEY;

-- Check completion status distribution
SELECT COMPLETION_STATUS, COUNT(*) as count 
FROM PRODUCT_SURVEY 
GROUP BY COMPLETION_STATUS 
ORDER BY count DESC;

-- Check NPS category distribution
SELECT NPS_CATEGORY, COUNT(*) as count 
FROM PRODUCT_SURVEY 
WHERE NPS_CATEGORY IS NOT NULL
GROUP BY NPS_CATEGORY 
ORDER BY count DESC;

-- Check satisfaction levels
SELECT SATISFACTION_CATEGORY, COUNT(*) as count 
FROM PRODUCT_SURVEY 
WHERE SATISFACTION_CATEGORY IS NOT NULL
GROUP BY SATISFACTION_CATEGORY 
ORDER BY count DESC;

-- Average ratings by category
SELECT 
    PRODUCT_CATEGORY,
    ROUND(AVG(OVERALL_SATISFACTION), 2) as avg_satisfaction,
    ROUND(AVG(PRODUCT_QUALITY_RATING), 2) as avg_quality,
    ROUND(AVG(VALUE_FOR_MONEY_RATING), 2) as avg_value,
    ROUND(AVG(NPS_SCORE), 2) as avg_nps,
    COUNT(*) as review_count
FROM PRODUCT_SURVEY 
WHERE OVERALL_SATISFACTION IS NOT NULL
GROUP BY PRODUCT_CATEGORY 
ORDER BY avg_satisfaction DESC;
