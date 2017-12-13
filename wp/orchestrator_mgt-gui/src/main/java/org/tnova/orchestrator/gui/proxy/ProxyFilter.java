package org.tnova.orchestrator.gui.proxy;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class ProxyFilter implements Filter {

    public ProxyFilter() {
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        // Store request path to HTTP Request object
        request.setAttribute("uri", req.getRequestURI().substring(req.getContextPath().length()));
        // Forward filtered requests to MyProxy servlet
        request.getRequestDispatcher("/ProxyServlet").forward(request, response);
    }

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
    }

}
