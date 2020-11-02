package com.eggs.chickendash;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import io.swagger.jaxrs.config.BeanConfig;

public class SwaggerBootstrap extends HttpServlet {
    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        BeanConfig beanConfig = new BeanConfig();
        beanConfig.setVersion("1.0.0");
        beanConfig.setSchemes(new String[]{"http", "https"});
        beanConfig.setHost("chickendash.mybluemix.net");
        beanConfig.setBasePath("/services");
        beanConfig.setResourcePackage("com.eggs.chickendash");
        //beanConfig.setResourcePackage("io.swagger.resources");
        beanConfig.setPrettyPrint(true);
        beanConfig.setContact("Tom Eggebraaten");
        beanConfig.setScan(true);
    }
}