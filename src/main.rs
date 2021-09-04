use lambda_http::{
    handler,
    http::StatusCode,
    lambda_runtime::{self, Context, Error},
    Request, RequestExt, Response,
};

#[tokio::main]
async fn main() -> Result<(), Error> {
    lambda_runtime::run(handler(func)).await?;
    Ok(())
}

async fn func(request: Request, _: Context) -> Result<Response<String>, Error> {
    let query_string = request.query_string_parameters();

    let first_name = query_string.get("firstName").unwrap_or("stranger");

    let response = Response::builder().status(StatusCode::OK);

    Ok(response
        .body(format!("Hello, my name is {}!", first_name))
        .unwrap())
}
