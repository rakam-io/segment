{% macro segment_web_page_views() %}

    {{ adapter_macro('segment.segment_web_page_views') }}

{% endmacro %}


{% macro default__segment_web_page_views() %}

with source as (

    select * from {{var('segment_page_views_table')}}
    
),

renamed as (

    select
    
        id as page_view_id,
        anonymous_id,
        user_id,
        
        received_at as received_at_tstamp,
        sent_at as sent_at_tstamp,        
        timestamp as tstamp,

        url as page_url,
        split_part(split_part(split_part(url, '//', 2),'/', 1),'?',1)::varchar 
            as page_url_host,
        path as page_url_path,
        title as page_title,
        search as page_url_query,
        
        referrer,
        ltrim(split_part(split_part(referrer, '.com', 1), '//',2),'www.')::varchar 
            as referrer_host,
        
        context_campaign_source as utm_source,
        context_campaign_medium as utm_medium,
        context_campaign_name as utm_campaign,
        context_campaign_term as utm_term,
        context_campaign_content as utm_content,
        nullif(split_part(split_part(url, 'gclid=', 2),'&', 1)::varchar,'') 
            as gclid,

        context_ip as ip,        
        context_user_agent as user_agent
                        
    from source

)

select * from renamed

{% endmacro %}


{% macro snowflake__segment_web_page_views() %}

with source as (

    select * from {{var('segment_page_views_table')}}
    
),

renamed as (

    select
    
        id as page_view_id,
        anonymous_id,
        user_id,
        
        received_at as received_at_tstamp,
        sent_at as sent_at_tstamp,        
        timestamp as tstamp,

        url as page_url,
        parse_url(url)['host']::varchar as page_url_host,
        path as page_url_path,
        title as page_title,
        search as page_url_query,
        
        referrer,
        parse_url(referrer)['host']::varchar as referrer_host,
        
        context_campaign_source as utm_source,
        context_campaign_medium as utm_medium,
        context_campaign_name as utm_campaign,
        context_campaign_term as utm_term,
        context_campaign_content as utm_content,
        nullif(parse_url(url)['parameters']['gclid']::varchar, '') as gclid,

        context_ip as ip,        
        context_user_agent as user_agent
                        
    from source

)

select * from renamed

{% endmacro %}