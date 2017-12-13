/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.tnova.orchestrator.gui.services;

/**
 *
 * @author Josep Batallé <josep.batalle@i2cat.net>
 */
public class RestServiceException extends Exception {

	/**
	 * 
	 */
	private static final long	serialVersionUID	= 1L;

	/**
	 * 
	 */
	public RestServiceException() {
	}

	/**
	 * @param message
	 */
	public RestServiceException(String message) {
		super(message);
	}

	/**
	 * @param cause
	 */
	public RestServiceException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public RestServiceException(String message, Throwable cause) {
		super(message, cause);
	}

}
