/*
 * #%L
 * Alfresco Legacy Lucene
 * %%
 * Copyright (C) 2005 - 2016 Alfresco Software Limited
 * %%
 * This file is part of the Alfresco software. 
 * If the software was purchased under a paid Alfresco license, the terms of 
 * the paid license agreement will prevail.  Otherwise, the software is 
 * provided under the following open source license terms:
 * 
 * Alfresco is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Alfresco is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with Alfresco. If not, see <http://www.gnu.org/licenses/>.
 * #L%
 */
package org.alfresco.repo.search.impl.lucene.analysis;

import java.io.IOException;
import java.io.Reader;

import org.alfresco.util.NumericEncoder;
import org.apache.lucene.analysis.Token;
import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.WhitespaceTokenizer;

/**
 * Simple tokeniser for integers.
 * 
 * @author Andy Hind
 */
public class IntegerTokenFilter extends Tokenizer
{
    Tokenizer baseTokeniser;
    
    public IntegerTokenFilter(Reader in)
    {
        super(in);
        baseTokeniser = new WhitespaceTokenizer(in);
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.apache.lucene.analysis.TokenStream#next()
     */

    public Token next() throws IOException
    {
        Token candidate;
        while((candidate = baseTokeniser.next()) != null)
        {
            try
            {
                Integer integer = Integer.valueOf(candidate.termText());
                String valueString = NumericEncoder.encode(integer.intValue());
                Token integerToken = new Token(valueString, candidate.startOffset(), candidate.startOffset(),
                        candidate.type());
                return integerToken;
            }
            catch (NumberFormatException e)
            {
                // just ignore and try the next one
            }
        }
        return null;
    }
}