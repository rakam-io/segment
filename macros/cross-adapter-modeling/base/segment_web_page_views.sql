{% macro segment_web_page_views() %}

    {{ adapter_macro('segment.segment_web_page_views') }}

{% endmacro %}


{% macro default__segment_web_page_views() %}

{{ exceptions.raise_compiler_error("macro segment_web_page_views not implemented for this adapter") }}

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